class AppDelegate
  attr_accessor :window

  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = IPKeyboardController.new
    @window.makeKeyAndVisible

    true
  end
end