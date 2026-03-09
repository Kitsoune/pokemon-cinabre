# Pokémon Cinabre - Speed Up (Position & Style Update)
@last_alt_state = false
@speed_text = nil
@speed_timer = 0

Scheduler.add_proc(:on_update, :any, 'SpeedUpCinabre', 10_000) do
  # 1. Détection de la touche Alt
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
    
    # 2. Gestion de l'affichage
    target_v = $scene.instance_variable_get(:@viewport) || $scene.viewport rescue nil
    
    if target_v
      if @speed_text.nil? || @speed_text.disposed?
        # Y est passé de 10 à 5 pour être plus haut
        @speed_text = Text.new(0, target_v, 10, 5, 120, 40, display_string)
        @speed_text.z = 100000
      else
        @speed_text.text = display_string
      end
      
      @speed_text.opacity = 255
      @speed_timer = 60
      
      # Son progressif selon la vitesse
      Audio.se_play("Graphics/Audio/SE/Select", 80, 100 + (multiplier * 10))
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