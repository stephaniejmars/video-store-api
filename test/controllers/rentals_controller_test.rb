require "test_helper"

describe RentalsController do
  
  RENTAL_FIELDS = ['available_inventory', 'videos_checked_out_count', 'customer_id', 'video_id', 'due_date'].sort
  
  describe "check_out" do 
    
    let(:customer) {
      customers(:junito)
    }
    
    let(:video) {
      videos(:brazil)
    }
    
    it "can get checkout path, creates a new rental with valid information and responds with success" do       
      rental_info = {
        customer_id: customer.id,
        video_id: video.id
      }
      
      count = customer.videos_checked_out_count
      vid_count = video.available_inventory
      
      post check_out_path(params: rental_info)
      customer.reload
      video.reload
      
      body = JSON.parse(response.body)
      
      must_respond_with :success
      expect(response.header['Content-Type']).must_include 'json'
      expect(body.keys.sort).must_equal RENTAL_FIELDS
      expect(body["due_date"]).must_equal (Date.today + 7).to_s
      expect(body["customer_id"]).must_equal customer.id
      expect(body["video_id"]).must_equal video.id
      expect(body["videos_checked_out_count"]).must_equal customer.videos_checked_out_count
      expect(body["available_inventory"]).must_equal video.available_inventory
      
      expect(customer.videos_checked_out_count).must_equal count + 1
      expect(video.available_inventory).must_equal vid_count - 1
      
    end 
    
    it "responds with not_found if customer is nil" do
      rental_info = {
        customer_id: 'pizza',
        video_id: video.id
      }
      
      expect {
        post check_out_path, params: rental_info
      }.wont_change "Rental.count"
      
      body = JSON.parse(response.body)
      
      must_respond_with :not_found
      expect(body).must_be_instance_of Hash 
      expect(body['errors']).must_equal ['Not Found']
    end
    
    
    
    it "responds with not_found if video is nil" do
      rental_info = {
        customer_id: customer.id,
        video_id: 'sandwich',
      }
      
      expect {
        post check_out_path, params: rental_info
      }.wont_change "Rental.count"
      
      body = JSON.parse(response.body)
      
      must_respond_with :not_found
      expect(body).must_be_instance_of Hash 
      expect(body['errors']).must_equal ['Not Found']
    end
    
    it 'responds with bad_request if there are no videos available' do
      
    end
    
    
    
    
    
    
  end 
  
  describe "check_in" do 
    
  end 
end