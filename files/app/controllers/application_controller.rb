class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  # before_filter :protect

  # def protect
  #   @ips = ['127.0.0.1', '192.168.1.0/24']
  #   allowed = false
  #   # Convert remote IP to an integer.
  #   bremote_ip = request.remote_ip.split('.').map(&:to_i).pack('C*').unpack('N').first
  #   @ips.each do |ipstring|
  #     ip, mask = ipstring.split '/'
  #     # Convert tested IP to an integer.
  #     bip = ip.split('.').map(&:to_i).pack('C*').unpack('N').first
  #     # Convert mask to an integer, and assume /32 if not specified.
  #     mask = mask ? mask.to_i : 32
  #     bmask = ((1 << mask) - 1) << (32 - mask)
  #     if bip & bmask == bremote_ip & bmask
  #       allowed = true
  #       break
  #     end
  #   end

  #   if not allowed
  #     render :text => "You are unauthorized"
  #     return
  #   end
  # end
end
