require 'test_helper'

class ReadReceiptsControllerTest < ActionController::TestCase
  setup do
    @read_receipt = read_receipts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:read_receipts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create read_receipt" do
    assert_difference('ReadReceipt.count') do
      post :create, read_receipt: { member_id: @read_receipt.member_id, message_id: @read_receipt.message_id }
    end

    assert_redirected_to read_receipt_path(assigns(:read_receipt))
  end

  test "should show read_receipt" do
    get :show, id: @read_receipt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @read_receipt
    assert_response :success
  end

  test "should update read_receipt" do
    put :update, id: @read_receipt, read_receipt: { member_id: @read_receipt.member_id, message_id: @read_receipt.message_id }
    assert_redirected_to read_receipt_path(assigns(:read_receipt))
  end

  test "should destroy read_receipt" do
    assert_difference('ReadReceipt.count', -1) do
      delete :destroy, id: @read_receipt
    end

    assert_redirected_to read_receipts_path
  end
end
