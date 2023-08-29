module DevicesHelper

  def set_arn_for_device(user, params)
    user_device = params[:device]
    if user_device
      if user_device[:push_token].blank? or user_device[:identifier].blank?
        return false, I18n.t('error.notifications.missing_params')
      end
      puts user.id
      if user.devices.current_devices_count(user_device[:push_token]) > 0
        return true
      elsif user.devices.empty? or (user_device[:identifier] && !user_device[:push_token].empty?)
        @sns ||= SnsNotification.new
        device = user.devices.new(device_params params)
        unless device.valid?
          destroy_devices(nil, device, device.push_token)
        end
        success, device.arn = @sns.create_endpoint(user_device[:identifier], device.push_token, user.id.to_s)
        if success
          @sns.update_token(device.arn, device.push_token, user.id.to_s)
          device.save
          return true
        end
      end
    end
    false
  end

  def destroy_devices(user = nil, device = nil, push_token)
    @sns ||= SnsNotification.new
    @devices = Device.where(push_token: push_token)
    @devices = @devices.where.not(id: device&.id) if device.present?
    @devices = @devices.where(user_id: user.id) if user.present?
    @devices.find_each do |device_to_delete|
      @sns.delete_endpoint device_to_delete.arn
      device_to_delete.destroy
    end
  end

  private

  def device_params params
    params.require(:device).permit(:identifier, :push_token, :os, :app, :model)
  end

end