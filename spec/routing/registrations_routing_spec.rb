# Source: https://github.com/rspec/rspec-rails/blob/6-1-maintenance/lib/generators/rspec/scaffold/templates/routing_spec.rb
require "rails_helper"

RSpec.describe RegistrationsController do
  describe "routing!!!" do
    it "routes to #index" do
      expect(get: "/registrations").not_to be_routable
    end

    it "routes to #new" do
      expect(get: "/registrations/new").to route_to("registrations#new")
    end

    it "routes to #show" do
      expect(get: "/registrations/1").not_to be_routable
    end

    it "routes to #edit" do
      expect(get: "/registrations/1/edit").not_to be_routable
    end

    it "routes to #create" do
      expect(post: "/registrations").to route_to("registrations#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/registrations/1").not_to be_routable
    end

    it "routes to #update via PATCH" do
      expect(patch: "/registrations/1").not_to be_routable
    end

    it "routes to #destroy" do
      expect(delete: "/registrations/1").not_to be_routable
    end
  end
end
