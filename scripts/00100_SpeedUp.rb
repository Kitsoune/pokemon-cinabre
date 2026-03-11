# Pokémon Cinabre - Speed Up (Version Stable Universelle)
@last_alt_state = false
@speed_text = nil
@speed_timer = 0
@current_scene_at_click = nil

Scheduler.add_proc(:on_update, :any, 'SpeedUpCinabre', 10_000) do
  # 1. Maintien de la vitesse en combat (Correction du verrou PSDK)
  if $scene.class.to_s.include?('Battle') && Graphics.frame_rate > 60
    # On s'assure que le moteur de combat ne repasse pas à 60
    # multiplier = @last_multiplier_value || 1
    # Graphics.frame_rate = 60 * multiplier
  end

  # 2. Détection de la touche Alt
  is_alt_pressed = Input::Keyboard.press?(Input::Keyboard::LAlt) || Input::Keyboard.press?(Input::Keyboard::RAlt)
  
  if is_alt_pressed && !@last_alt_state
    # Cycle de vitesse
    if Graphics.frame_rate < 240
      Graphics.frame_rate += 60
    else
      Graphics.frame_rate = 60
    end
    
    multiplier = Graphics.frame_rate / 60
    display_string = ">> x#{multiplier}"

    if $scene
      # Nettoyage si changement de scène
      if @current_scene_at_click != $scene.class
        @speed_text.dispose if @speed_text && !@speed_text.disposed?
        @speed_text = nil
        @current_scene_at_click = $scene.class
      end

      # Cible le viewport
      target_v = $scene.instance_variable_get(:@viewport) || 
                 $scene.instance_variable_get(:@main_viewport) rescue nil
      
      if target_v
        if @speed_text.nil? || @speed_text.disposed?
          @speed_text = Text.new(0, target_v, 10, 5, 120, 40, display_string)
          @speed_text.z = 1000000
        else
          @speed_text.text = display_string
        end
        @speed_text.opacity = 255
        @speed_timer = 60
        Audio.se_play("Graphics/Audio/SE/Select", 80, 100 + (multiplier * 10))
      end
    end
  end
  
  # 3. Animation de disparition
  if @speed_timer > 0
    @speed_timer -= 1
    if @speed_text && !@speed_text.disposed?
      @speed_text.opacity -= 10 if @speed_timer < 25
    end
  elsif @speed_text && !@speed_text.disposed? && @speed_text.opacity > 0
    @speed_text.opacity = 0
  end
  
  @last_alt_state = is_alt_pressed
end