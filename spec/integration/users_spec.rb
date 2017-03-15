require 'swagger_helper'

describe 'My API' do

  path '/users' do

    post 'Creates a user' do
      tags 'Users'
      consumes 'application/json', 'application/xml'
      parameter name: :user, in: :body, schema: {
          type: :object,
          properties: {
              login: { type: :string },
              name: { type: :string },
              email: { type: :string },
              password: { type: :string },
              password_confirmation: { type: :string }
          },
          required: [ 'login', 'name', 'email', 'password', 'password_confiramtion' ]
      }

      response '201', 'user created' do
        let(:user) { { login: 'Cclara', name: 'Cclara Oswald', email: 'osswald@mail.com', password: '123123', password_confirmation: '123123'} }
        run_test!
      end

      response '422', 'invalid request' do
        let(:user) { { login: 'foo' } }
        run_test!
      end
    end
  end

  path '/users/{id}' do

    get 'Retrieves a user' do
      tags 'Users'
      produces 'application/json', 'application/xml'
      parameter name: :id, :in => :path, :type => :string

      # response '200', 'user found' do
      #   schema type: :object,
      #          properties: {
      #              id: { type: :integer },
      #              login: { type: :string },
      #              name: { type: :string },
      #              email: { type: :string }
      #          },
      #          required: [ 'id', 'login', 'name', 'email']
      #
      #   let(:id) { User.create(login: 'Cclara', name: 'Cclara Oswald', email: 'osswald@mail.com', password: '123123', password_confirmation: '123123').id }
      #   run_test!
      # end

      response '404', 'user not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end
  end
end