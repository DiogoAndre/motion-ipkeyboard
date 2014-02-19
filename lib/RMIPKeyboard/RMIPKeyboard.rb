module RMIPKeyboard
  class Keyboard < UIView
    HEX_KEYBOARD_HEIGHT = 305
    DEC_KEYBOARD_HEIGHT = 205
    SGRAYCOLOUR = UIColor.lightTextColor

    def initWithTextFieldAndLayout(textField, klayout="ipv6")
      if klayout == "ipv6"
        @keyboardHeight = HEX_KEYBOARD_HEIGHT
        @numrows = 6.0
        @dividerChar = ":"
        @numberOfKeys = 15 # minus one
      else
        @keyboardHeight = DEC_KEYBOARD_HEIGHT
        @numrows = 4.0
        @dividerChar = "."
        @numberOfKeys = 9 # minus one
      end

      self.initWithFrame(CGRectMake(0.0, 0.0, 320.0, @keyboardHeight))

      @textField = WeakRef.new(textField)
      self.backgroundColor = UIColor.lightGrayColor
      self.createButtons

      self
    end

    def createButtons
      rect = CGRectMake(0.0, 0.0, ((self.bounds.size.width / 3.0) + 0.3).floor, (((@keyboardHeight - 5.0) / @numrows) + 0.3))

      # Makes the numerical buttons
      (1..@numberOfKeys).each do |num|
        rect.origin = self.buttonOriginPointForNumber(num)

        self.makeButtonWithRect(rect,self.buttonTitleForNumber(num),false)
      end
      # Makes the ':' button
      rect.origin = self.buttonOriginPointForNumber(@numberOfKeys + 1)

      self.makeButtonWithRect(rect,@dividerChar,true)

      # Makes the '0' button
      rect.origin = self.buttonOriginPointForNumber(@numberOfKeys + 2)

      self.makeButtonWithRect(rect,"0",false)

      # Makes the 'delete' button
      rect.origin = self.buttonOriginPointForNumber(@numberOfKeys + 3)

      button = UIButton.alloc.initWithFrame(rect)
      button.tag = @numberOfKeys + 3
      button.backgroundColor = SGRAYCOLOUR
      button.setImage(UIImage.imageNamed("deleteButton"), forState:UIControlStateNormal)
      button.addTarget(self, action:"changeButtonBackgroundColourForHighlight:", forControlEvents:(UIControlEventTouchDown|UIControlEventTouchDragEnter|UIControlEventTouchDragExit))
      button.addTarget(self, action:"changeTextFieldText:", forControlEvents:UIControlEventTouchUpInside)

      self.addSubview(button)
    end

    def makeButtonWithRect(rect, title, grayBackground)
      button = UIButton.buttonWithType(UIButtonTypeCustom)
      button.frame = rect
      fontSize = 25.0

      unless  NSCharacterSet.decimalDigitCharacterSet.isSupersetOfSet(NSCharacterSet.characterSetWithCharactersInString(title))
        fontSize = 20.0
      end

      button.backgroundColor = grayBackground ? SGRAYCOLOUR : UIColor.whiteColor
      #button.backgroundColor = grayBackground ? UIColor.lightTextColor : UIColor.whiteColor
      button.titleLabel.font = UIFont.systemFontOfSize(fontSize)
      button.setTitleColor(UIColor.darkTextColor, forState:UIControlStateNormal)
      button.setTitle(title, forState:UIControlStateNormal)
      button.addTarget(self, action:"changeButtonBackgroundColourForHighlight:", forControlEvents: (UIControlEventTouchDown|UIControlEventTouchDragEnter|UIControlEventTouchDragExit))
      button.addTarget(self, action:"changeTextFieldText:", forControlEvents: UIControlEventTouchUpInside)

      self.addSubview(button)
    end

    def buttonTitleForNumber(num)
      str = num.to_s
      if num <= 15
        if num >= 10
          str = ["A", "B", "C", "D", "E", "F"][num - 10]
        end
      else
        str = "F#%K"
      end
      str
    end

    def buttonOriginPointForNumber(num)
      point = CGPointMake(0.0,0.0)

      if (num % 3) == 2 # 2nd button in the row
        point.x = (self.bounds.size.width / 3.0).ceil
      elsif (num % 3) == 0 # 3rd button in the row
        point.x = (self.bounds.size.width / 3.0 * 2.0).ceil
      end

      if num > 3 # The row multiplied by row's height
        point.y = ((num - 1) / 3.0).floor * (@keyboardHeight / @numrows)
      end
      point
    end

    def changeButtonBackgroundColourForHighlight(button)
      if button.backgroundColor == SGRAYCOLOUR
         button.backgroundColor = UIColor.whiteColor
      else
         button.backgroundColor = SGRAYCOLOUR
      end
    end

    def changeTextFieldText(button)
      if button.tag == @numberOfKeys + 3
        @textField.text = "#{@textField.text.chop}"
      else
        @textField.text = "#{@textField.text}#{button.titleLabel.text}"
      end
      self.changeButtonBackgroundColourForHighlight(button)
    end

  end
end