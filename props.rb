__ :name => "screen", :id => "screen"
game_over_message :id => "game_over_message", :x => '300', :y => '300'
help_screen :id => "help_screen", :x => '400' , :y => '200'
about_screen :id => "about_screen", :x => '400', :y =>'400'
quit_screen :id => "quit_screen", :x => '200', :y => '300' do
  quit_confirm :id => "quit_confirm", :text => "Confirm Quit"
  cancel :id => "cancel", :text => "Cancel"
end

win_screen :id => "win_screen", :x => '300', :y => '300'

menu_screen :id =>  "menu_screen" , :x => '200', :y => '200' do
  menu_title :text => "Menu Options"
  resume :id => "resume", :text => "Resume"
  restart :id => "restart", :text => "Restart"
  sound_option :id => "sound_option", :text => "Sound: On"
  help :id => "help", :text => "Help"
  about :id => "about", :text => "About"
  quit :id => "quit", :text => "Quit"
end
title :text => "Space Tower Defense"
money_label :text => "Money:", :id => "money_label"
wave_label :text => "Waves:", :id => "wave_label"
lives_label :text => "Lives:", :id => "lives_label"
holding_panel do
  wave_countdown :id => "wave_countdown", :text => "Next Creep Wave in: #{Space::CLOCK}"
  next_creep_display :id => "next_creep_display"
  empty_block
  start :id => "start", :text => "Send Wave"
  3.times {empty_block}
  menu :id => "menu", :text => "Menu"
end
space_frame :id => "space_frame" do
  start_realm :text => "Start Realm"
end
build_panel :id => "build_panel" do
  icon_panel do     
    tower_icon :id => "KineticTower", :background_image => "images/towerIcons/KineticTower.png"
    tower_icon :id => "GammaTower", :background_image => "images/towerIcons/GammaTower.png"
    tower_icon :id => "HotNeedleOfInquiry", :background_image => "images/towerIcons/HotNeedleOfInquiry.png"
    tower_icon :id => "TimeWrappingTower", :background_image => "images/towerIcons/TimeWrappingTower.png"
    tower_icon :id => "ImprobabilityTower", :background_image => "images/towerIcons/ImprobabilityTower.png"
    tower_icon :id => "DimensionalPhaseTower", :background_image => "images/towerIcons/DimensionalPhaseTower.png"
    tower_icon :id => "GravityTower", :background_image => "images/towerIcons/GravityTower.png"
  end
  build_option_panel :id => "build_option_panel" do
     tower_info :id => "tower_info", :text => "Click on a tower icon to see its information and stats."
     upgrade :id => "upgrade", :text => "Upgrade"
     sell :id => "sell", :text => "Sell"
   end
 end

