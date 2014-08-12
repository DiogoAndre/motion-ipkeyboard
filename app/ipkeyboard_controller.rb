class IPKeyboardController < UIViewController

  def viewDidLoad
    super

    self.view.backgroundColor = UIColor.groupTableViewBackgroundColor

    ipv6_input_field = UITextField.alloc.initWithFrame(CGRectMake(10, 100, 300, 45))
    ipv6_input_field.setBackgroundColor(UIColor.whiteColor)
    ipv6_input_field.inputView = RMIPKeyboard::Keyboard.alloc.initWithTextFieldAndLayout(ipv6_input_field,"ipv6")
    ipv6_input_field.setAccessibilityLabel("IPv6")
    ipv6_input_field.setDelegate(self)

    ipv4_input_field = UITextField.alloc.initWithFrame(CGRectMake(10, 50, 300, 45))
    ipv4_input_field.setBackgroundColor(UIColor.whiteColor)
    ipv4_input_field.inputView = RMIPKeyboard::Keyboard.alloc.initWithTextFieldAndLayout(ipv4_input_field,"ipv4")
    ipv4_input_field.setAccessibilityLabel("IPv4")
    ipv4_input_field.setDelegate(self)

    self.view.addSubview(ipv6_input_field)
    self.view.addSubview(ipv4_input_field)
  end

end
