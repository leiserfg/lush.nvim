describe "hsl", ->
  hsl = require('lush.hsl')

  describe "creation", ->
    it "can be created from h,s,l", ->
      assert.is.not.nil(hsl)
      color = hsl(120, 10, 10)
      assert.not.nil(color)
      color = hsl(361, 111, 302)
      assert.is.equal(color.h, 1)
      assert.is.equal(color.s, 100)
      assert.is.equal(color.l, 100)

      -- these values should just be clamped
      color = hsl(-365, -111, -102)
      assert.is.equal(color.h, 355)
      assert.is.equal(color.s, 0)
      assert.is.equal(color.l, 0)

  it "can be created from a hex value", ->
    color = hsl("#FF0000")
    assert.is_equal(0, color.h)
    assert.is_equal(100, color.s)
    assert.is_equal(50, color.l)

    color = hsl("#00FF00")
    assert.is_equal(120, color.h)
    assert.is_equal(100, color.s)
    assert.is_equal(50, color.l)

    color = hsl("#0000fF")
    assert.is_equal(240, color.h)
    assert.is_equal(100, color.s)
    assert.is_equal(50, color.l)

    color = hsl("#fe20d5")
    assert.is_equal(311, color.h)
    assert.is_equal(99, color.s)
    assert.is_equal(56, color.l)

  it "errors on bad arguments", ->
    check_e = (fn) ->
      e = assert.error(fn)
      assert.matches("hsl%(%) expects", e)
    check_e(-> hsl())
    check_e(-> hsl(1))
    check_e(-> hsl(1,2))
    check_e(-> hsl(2, 3, "3"))
    check_e(-> hsl(23, 3))
    assert.error(-> color hsl(""))
    assert.error(-> color hsl("hsl('#100000')"))
    assert.error(-> color hsl("#0df"))
    assert.error(-> color hsl("#00FF0Z"))

  describe "modification", ->
    color = hsl(120, 11, 34)

    it "can rotate", ->
      assert.is.equal(color.h, 120)
      assert.is.equal(120, color.rotate(0).h)
      assert.is.equal(120 + 40, color.rotate(40).h)
      assert.is.equal((120 + 240) % 360, color.rotate(240).h)
      assert.is.equal(color.rotate(-10).h, 110)
      assert.is.equal(color.rotate(-120).h, 0)
      assert.is.equal(color.rotate(-125).h, 355)

      assert.is_same(color.rotate(120).h, color.ro(120).h)

    it "can saturate", ->
      assert.is.equal(color.s, 11)
      assert.is.equal(color.saturate(10).s, 20)
      assert.is.equal(color.saturate(-10).s, 10)
      assert.is.equal(color.saturate(-110).s, 0)
      assert.is.equal(color.saturate(110).s, 100)

      assert.is.equal(color.abs_saturate(10).s, 21)
      assert.is.equal(color.abs_saturate(-10).s, 1)
      assert.is.equal(color.abs_saturate(-110).s, 0)
      assert.is.equal(color.abs_saturate(110).s, 100)

      assert.is_same(color.saturate(10).s, color.sa(10).s)
      assert.is_same(color.abs_saturate(10).s, color.abs_sa(10).s)

    it "can desaturate", ->
      assert.is.equal(color.s, 11)
      assert.is.equal(color.desaturate(10).s, 10)
      assert.is.equal(color.desaturate(-10).s, 20)
      assert.is.equal(color.desaturate(-110).s,100)
      assert.is.equal(color.desaturate(110).s, 0)

      assert.is.equal(color.s, 11)
      assert.is.equal(color.abs_desaturate(10).s, 1)
      assert.is.equal(color.abs_desaturate(-10).s, 21)
      assert.is.equal(color.abs_desaturate(-110).s,100)
      assert.is.equal(color.abs_desaturate(110).s, 0)

      assert.is_same(color.desaturate(10).s, color.de(10).s)
      assert.is_same(color.abs_desaturate(10).s, color.abs_de(10).s)

    it "can lighten", ->
      assert.is.equal(color.l, 34)
      assert.is.equal(color.lighten(10).l, 41)
      assert.is.equal(color.lighten(-10).l, 31)
      assert.is.equal(color.lighten(-110).l, 0)
      assert.is.equal(color.lighten(110).l, 100)

      assert.is.equal(color.l, 34)
      assert.is.equal(color.abs_lighten(10).l, 44)
      assert.is.equal(color.abs_lighten(-10).l, 24)
      assert.is.equal(color.abs_lighten(-110).l, 0)
      assert.is.equal(color.abs_lighten(110).l, 100)

      assert.is_same(color.lighten(10).l, color.li(10).l)
      assert.is_same(color.abs_lighten(10).l, color.abs_li(10).l)

    it "can darken", ->
      assert.is.equal(color.l, 34)
      assert.is.equal(color.darken(10).l, 31)
      assert.is.equal(color.darken(-10).l, 41)
      assert.is.equal(color.darken(-110).l,100)
      assert.is.equal(color.darken(110).l, 0)

      assert.is.equal(color.l, 34)
      assert.is.equal(color.abs_darken(10).l, 24)
      assert.is.equal(color.abs_darken(-10).l, 44)
      assert.is.equal(color.abs_darken(-110).l,100)
      assert.is.equal(color.abs_darken(110).l, 0)

      assert.is_same(color.darken(10).l, color.da(10).l)
      assert.is_same(color.abs_darken(10).l, color.abs_da(10).l)

    it "can set direct values", ->
      assert.is.equal(color.h, 120)
      assert.is.equal(color.hue(55).h, 55)
      assert.is.equal(color.s, 11)
      assert.is.equal(color.saturation(55).s, 55)
      assert.is.equal(color.l, 34)
      assert.is.equal(color.lightness(44).l, 44)

    it "disables assignment", ->
      color = hsl(0, 0, 0)
      assert.error(-> color.h = 100)

  describe "modifier behaviour", ->
    it "can chain modifiers", ->
      color = hsl(120, 11, 34)
      mod_color = color.rotate(10).lighten(20).desaturate(20).rotate(20)
      assert.is_same({h: 150, s: 9, l: 47}, mod_color())

    it "can modifiers don't modifiy original color", ->
      color = hsl(120, 11, 34)
      mod_color = color.rotate(10).lighten(20).desaturate(20).rotate(20)
      assert.is_not_equal(color, mod_color)
      assert.is_not_equal(color(), mod_color())

  describe "unpacking", ->
    it "unrolls to table when called", ->
      color = hsl(120, 11, 34)
      assert.not.nil(color())
      assert.is.table(color())
      assert.is.equal(color().h, 120)
      assert.is.equal(color().s, 11)
      assert.is.equal(color().l, 34)

    it "has .h, .s, .l helpers", ->
      color = hsl(120, 11, 34)
      assert.is.equal(color.h, 120)
      assert.is.equal(color.s, 11)
      assert.is.equal(color.l, 34)

    it "can concat with strings", ->
      color = hsl(0,0,0)
      str_start = "my color is: "
      assert.is_equal(str_start .. "#000000", str_start .. color)

    it "can convert to hex", ->
      color = hsl(0, 0, 0)
      assert.is_equal("#000000", tostring(color))

      assert.is.equal(hsl(0,0,0).hex, "#000000")
      assert.is.equal(hsl(120, 0, 0).hex, "#000000")
      assert.is.equal(hsl(0,0,100).hex, "#FFFFFF")
      assert.is.equal(hsl(0, 100, 50).hex, "#FF0000")
      assert.is.equal(hsl(120, 100, 50).hex, "#00FF00")
      assert.is.equal(hsl(240, 100, 50).hex, "#0000FF")
      assert.is.equal(hsl(123, 45, 67).hex, "#85D189")

      assert.is_equal(hsl(0,0,0) .. " color", "#000000 color")
      assert.is_equal("color " .. hsl(0,0,0), "color #000000")
