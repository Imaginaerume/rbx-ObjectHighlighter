# rbx-ObjectHighlighter
This module allows you to make an object or model act as "Always on Top" and layer over the normal 3D game world.
```--[[
Imaginaerum (devforum.roblox.com | roblox.com)
2/21/2019

Purpose:
  This module allows you to make an object or model act as "Always on Top" and layer over the normal 3D game world.

Usage:
  local HighlightObject = require(ObjectHighlight).new( 
    <optional Instance> Model or Part, 
    <optional Color3> Highlight color, 
    <optional bool> Hide if origin is visible, 
    <optional number> Maximum render distance
    <optional number> Transparency
  )

  Examples:

  1.
    local HighlightObject = require(ObjectHighlight).new(
      game.Players.LocalPlayer.Character,
      Color3.new(0,1,0),
      false,
      50,
      0
    )

    HighlightObject:Enable()

    ->> Produces and enables a Highlight that will make your character green unless the camera is more than 50 studs away

  2.
    local HighlightObject = require(ObjectHighlight).new(
      game.Players.LocalPlayer.Character,
      Color3.new(1,0,0),
      true,
      nil,
      0
    )

    HighlightObject:Enable()

    ->> Produces and enables a Highlight that will make your character red, but only if your character is obscured by another part.

Methods:
  <Instance HighlightObject> AddPart( <Instance> BasePart )
    -> Creates a new highlighted part with the properties of the HighlightObject

  <void> Enable()
    -> Parents the children of the HighlightObject to the ViewportFrame and adds them to the update queue

  <void> Disable()
    -> Parents the children of the HighlightObject to nil and removes them from the update queue

  <void> Destroy()
    -> Destroys the children of the HighlightObject and removes them from the update queue

  <void> ChangeTransparency( <number> NewTransparency )
    -> Changes the transparency of all the children of the HighlightObject

  <void> ChangeColor( <Color3> NewColor )
    -> Instantly changes the color of all the children of the HighlightObject to the given NewColor, or to the color of the corresponding original part if no NewColor is given.

  <Tween> TweenColor( <Color3> NewColor, <TweenInfo> TweenInfo)
    -> Same thing as 'ChangeColor', however it smoothly tweens the color of the parts based on the parameters of TweenInfo.
--]]```
