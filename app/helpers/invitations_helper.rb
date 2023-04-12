module InvitationsHelper
  def color_for_invitation(status)
    case status
    when 'pending'
      'bg-yellow-100 text-yellow-800'
    when 'accepted'
      'bg-green-100 text-green-800'
    when 'declined'
      'bg-red-100 text-red-800'
    end
  end

  def icon_for_invitation(level_or_status)
    case level_or_status
    when 'invited'
      "<i class='fa-solid fa-circle-user'></i>"
    when 'admin'
      "<i class='fa-solid fa-crown'></i>"
    when 'accept'
      "<i class='fa-solid fa-check'></i>"
    when 'decline'
      "<i class='fa-solid fa-times'></i>"
    end
  end
end
