screen {
  width 800
  height 700
  background_image "images/backgrounds/space.jpg"
}

title {
  width 500
  height 60
  horizontal_alignment :right
  vertical_alignment :center
  font_size 32
  text_color :black
  font_style "bold"
}

money_label {
  width 125
  height 50
  transparency 50
  font_size 16
  text_color :blue
  background_color '#aa33dd'
  horizontal_alignment :left
  vertical_alignment :center
  left_margin 30
  top_margin 20
}

wave_label {
  width 80
  height 50
  transparency 50
  font_size 16
  text_color :yellow
  background_color '#aa33dd'
  horizontal_alignment :left
  vertical_alignment :center
  top_margin 20
}

lives_label {
  width 80
  height 50
  transparency 50
  font_size 16
  text_color :green
  background_color '#aa33dd'
  horizontal_alignment :left
  vertical_alignment :center
  top_margin 20
}

holding_panel {
  width "100%"
  height 50
  horizontal_alignment :right
}

wave_countdown {
  width 190
  height 50
  bottom_margin 10
  top_margin 10
  right_margin 10
  text_color :green
  font_size 16
}

empty_block {
  width 50
  height 50
}
next_creep_display {
  width 25
  height 50
  right_margin 10
  bottom_margin 20
  top_margin 15
  background_image "images/Creep/creep1.png"
}
menu {
  width 110
  height 50
  right_margin 10
  top_margin 10
  bottom_margin 10
  horizontal_alignment :center
  vertical_alignment :center
  background_color :black
  secondary_background_color :red
  gradient :on
  gradient_penetration 90
  gradient_angle 330
  text_color "#1f1"
  font_size 24
  transparency 60
}
start {
  width 110
  height 40
  top_margin 10
  horizontal_alignment :center
  vertical_alignment :center
  background_color :red
  secondary_background_color :black
  gradient :on
  gradient_penetration 90
  gradient_angle 330
  text_color "#1f1"
  font_size 20
  transparency 60
}

win_screen {
  float :on
  width 0
  height 0
  horizontal_alignment :center
  vertical_alignment :center
  background_color :red
  secondary_background_color :black
  gradient :on
  gradient_penetration 90
  gradient_angle 330
  text_color "#1f1"
  font_size 20
  transparency 60
  
}

menu_screen {
  float :on
  width 0
  height 0
  background_color :red
  secondary_background_color :black
  gradient :on
  gradient_angle 180
  gradient_penetration 90
  horizontal_alignment :center
  vertical_alignment :center
  transparency 70
}

help_screen {
  float :on
  width 0
  height 0
  background_color :black
  secondary_background_color :red
  gradient :on
  gradient_angle 270
  gradient_penetration 90
  horizontal_alignment :center
  vertical_alignment :center
  transparency 60
  text_color "#1f1"
  font_size 16
}

about_screen {
  float :on
  width 0
  height 0
  background_color :black
  secondary_background_color :red
  gradient :on
  gradient_angle 270
  gradient_penetration 90
  horizontal_alignment :center
  vertical_alignment :center
  transparency 60
  text_color "#1f1"
  font_size 16
}

quit_screen {
  float :on
  width 0
  height 0
  background_color :red
  secondary_background_color :black
  gradient :on
  gradient_angle 100
  gradient_penetration 90
  horizontal_alignment :center
  vertical_alignment :center
  transparency 20
}
quit_confirm {
  width 110
  height 40
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 18
  horizontal_alignment :center
  vertical_alignment :center
}
cancel {
  width 70
  height 40
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 18
  horizontal_alignment :center
  vertical_alignment :center
}
menu_title {
  width 150
  height 45
  text_color '#11f'
  font_size 24
  top_margin 5
}

resume {
  width 110
  height 50
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 24
  horizontal_alignment :center
  vertical_alignment :center
  top_margin 10
}
restart {
  width 110
  height 50
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 24
  horizontal_alignment :center
  vertical_alignment :center
  top_margin 10
}
sound_option {
  width 110
  height 50
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 20
  horizontal_alignment :center
  vertical_alignment :center
  top_margin 10
}
help {
  width 110
  height 50
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 24
  horizontal_alignment :center
  vertical_alignment :center
  top_margin 10
}

about {
  width 110
  height 50
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 24
  horizontal_alignment :center
  vertical_alignment :center
  top_margin 10
}
quit {
  width 110
  height 50
  background_color :black
  transparency 70
  text_color '#1f1'
  font_size 24
  horizontal_alignment :center
  vertical_alignment :center
  top_margin 10
}

game_over_message {
  float :on
  width 0
  height 0
  background_color :green
  transparency 40
  text_color :black
  font_size 20
  horizontal_alignment :center
  vertical_alignment :center
}

space_frame {
  width 556
  height 506
  background_color :black
  transparency 50
  left_margin 50
  border_width 1
  border_color :black
}

build_panel {
  width 244
  height 506
  background_color :blue
  transparency 50
  left_margin 34
  right_margin 4
  border_width 3
  border_color :black
}
icon_panel {
  width '100%'
  height 100
}
build_option_panel {
  width 200
  height 300
}
upgrade {
  width 120
  height 50
  background_color :black
  transparency 0
  left_margin 10
  top_margin 10
  horizontal_alignment :center
  vertical_alignment :center
  text_color  '#1f1'
  font_size 24
  rounded_corner_radius 10
}
sell {
  width 80
  height 50
  background_color :black
  transparency 0
  left_margin 10
  right_margin 10
  top_margin 10
  horizontal_alignment :center
  vertical_alignment :center
  text_color  '#1f1'
  font_size 24
  rounded_corner_radius 10
}
tower_info {
  width 200
  height 200
  top_margin 10
  text_color '#1f1'
  font_size 14
  horizontal_alignment :center
  vertical_alignment :center
  background_color :black
  rounded_corner_radius 8
  transparency 30
}

start_realm {
  width 40
  height 20
  transparency 50
  background_color '#d11'
  font_size 8
}

creep {
  float :on
  width 15
  height 14
}
tower {
  float :on
  width 39
  height 39
}
tower_icon {
  width 33
  height 33
  top_margin 4
  left_margin 4
}
projectile {
  float :on
  width 10
  height 10
}
mouse_follower {
  float :on
  transparency "50"  
  width "38"
  height "37"
  x -100
  y -100
}
