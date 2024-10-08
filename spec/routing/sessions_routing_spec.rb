require "rails_helper"

RSpec.describe SessionsController do
  describe "routing" do
    context "when routes are routable" do
      it "routes to #new" do
        expect(get: "/session/new").to route_to("sessions#new")
      end

      it "routes to #create" do
        expect(post: "/session").to route_to("sessions#create")
      end

      it "routes to #destroy" do
        expect(delete: "/session").to route_to("sessions#destroy")
      end

      it "routes to #callback" do
        expect(post: "/session/callback").to route_to("sessions#callback")
      end
    end

    context "when routes are not routable" do
      it "routes to #show" do
        expect(get: "/session").not_to route_to("sessions#show")
      end

      it "routes to #edit" do
        expect(get: "/session/edit").not_to route_to("sessions#edit")
      end

      it "routes to #update via PUT" do
        expect(put: "/session").not_to route_to("sessions#update")
      end

      it "routes to #update via PATCH" do
        expect(patch: "/session").not_to route_to("sessions#update")
      end
    end
  end
end
