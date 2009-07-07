require 'test_helper'

class OwnersControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end
  
  def test_show
    get :show, :id => Owner.first
    assert_template 'show'
  end
  
  def test_new
    get :new
    assert_template 'new'
  end
  
  def test_create_invalid
    Owner.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end
  
  def test_create_valid
    Owner.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to owner_url(assigns(:owner))
  end
  
  def test_edit
    get :edit, :id => Owner.first
    assert_template 'edit'
  end
  
  def test_update_invalid
    Owner.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Owner.first
    assert_template 'edit'
  end
  
  def test_update_valid
    Owner.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Owner.first
    assert_redirected_to owner_url(assigns(:owner))
  end
  
  def test_destroy
    owner = Owner.first
    delete :destroy, :id => owner
    assert_redirected_to owners_url
    assert !Owner.exists?(owner.id)
  end
end
