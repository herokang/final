describe QuizsController do
  describe "routing" do
    it "recognizes and generates #index" do
      expect(get: "/teachers/exercise").to route_to(controller: "quizs", action: "index")
    end 
    it "recognizes and generates #create" do
      expect(post: "/teachers/createQuiz").to route_to(controller: "quizs", action: "create")
    end
    it "recognizes and generates #show" do
      expect(get: "/teachers/quizs").to route_to(controller: "quizs", action: "show")
    end
    it "recognizes and generates #publish" do
      expect(get: "/teachers/publish").to route_to(controller: "quizs", action: "publish")
    end
  end
end	