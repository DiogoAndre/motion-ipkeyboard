module RMIPKeyboard
  class Keyboard < UIView

    def initWithTextFieldAndLayout(textField, klayout="ipv6")
      
      define_constants
      calc_sizes(klayout)
      
      self.initWithFrame(CGRectMake(0.0, 0.0, @screen_width, @keyboardHeight))

      @textField = WeakRef.new(textField)
      self.backgroundColor = @bg_color
      self.createButtons
      self
    end
    
    def define_constants
      @bg_color = UIColor.lightGrayColor
      @text_color = UIColor.lightTextColor
      @screen_width = UIScreen.mainScreen.bounds.size.width
      @screen_height = UIScreen.mainScreen.bounds.size.height
    end
    
    def calc_sizes(klayout)
      
      if klayout == "ipv6"
        @key_height = 49
        @numrows = 6.0
        @dividerChar = ":"
        @numberOfKeys = 18
      else
        @key_height = 54
        @numrows = 4.0
        @dividerChar = "."
        @numberOfKeys = 12
        @first_origin        
      end
      
      @keyboardHeight = @key_height * @numrows
      @key_width  = @screen_width / 3.0
      @rect = CGRectMake(0.0, 0.0, @key_width, @key_height)    
    end

    def createButtons
      (1..@numberOfKeys).each do |num|
        @rect.origin = self.buttonOriginPointForNumber(num)
        self.makeButtonWithRect(@rect,num,false)
      end
    end

    def makeButtonWithRect(rect, num, grayBackground)
      button = UIButton.buttonWithType(UIButtonTypeCustom)
      button.frame = rect
      fontSize = 25.0

      button.backgroundColor = grayBackground ? @text_color : UIColor.whiteColor
      
      if num != @numberOfKeys
        button.titleLabel.font = UIFont.systemFontOfSize(fontSize)
        button.setTitleColor(UIColor.darkTextColor, forState:UIControlStateNormal)
        button.setTitle(buttonTitleForNumber(num), forState:UIControlStateNormal)
      else
        #button.backgroundColor = @text_color
        button.setImage(UIImage.imageNamed("deleteButton"), forState:UIControlStateNormal)
        button.setAccessibilityLabel("delete")
      end
      
      if num == @numberOfKeys || num == (@numberOfKeys - 2)
        button.backgroundColor = @text_color
      end
      
      button.tag = num
      button.addTarget(self, action:"changeButtonBackgroundColourForHighlight:", forControlEvents: (UIControlEventTouchDown|UIControlEventTouchDragEnter|UIControlEventTouchDragExit))
      button.addTarget(self, action:"changeTextFieldText:", forControlEvents: UIControlEventTouchUpInside)
      
      self.addSubview(button)
    end

    def buttonTitleForNumber(num)
      str = num.to_s
      
      if num > 9 && @numberOfKeys == 18
        str = ["a", "b", "c", "d", "e", "f",@dividerChar,"0","del"][num - 10]
      elsif num > 9
        str = [@dividerChar,"0","del"][num - 10]
      end
      str
    end
    
    def buttonOriginPointForNumber(num)
      point = CGPointMake(0.0,0.0)
    
      if (num % 3) == 2 # 2nd button in the row
        point.x = @key_width.ceil
      elsif (num % 3) == 0 # 3rd button in the row
        point.x = (@key_width * 2.0).ceil
      end
    
      if num > 3 # The row multiplied by row's height
        point.y = ((num - 1) / 3.0).floor * (@key_height + 0.5)
      end
      point
    end

    def changeButtonBackgroundColourForHighlight(button)
      if button.backgroundColor == @text_color
         button.backgroundColor = UIColor.whiteColor
      else
         button.backgroundColor = @text_color
      end
    end

    def changeTextFieldText(button)
      if button.tag == @numberOfKeys # Last key
        @textField.text = "#{@textField.text.chop}"
      else
        case @textField.delegate.respond_to?("textField:shouldChangeCharactersInRange:replacementString:")
        when true
          if @textField.delegate.textField(@textField,shouldChangeCharactersInRange: @textField.selectedTextRange, replacementString: button.titleLabel.text)
            @textField.insertText(button.titleLabel.text)
          end
        else
          @textField.insertText(button.titleLabel.text)
        end
      end
      self.changeButtonBackgroundColourForHighlight(button)
      @textField.sendActionsForControlEvents(UIControlEventEditingChanged)
    end

  end
end
