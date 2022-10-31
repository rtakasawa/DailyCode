# クラスで分岐するケース文のリファクタリング

# ----------修正前----------
class Trip
  def prepare(prepare_type)
    case prepare_type
    when Mechanic
      prepare_type.prepare_bicycle
    when Clerk
      prepare_type.prepare_ticket_reservation
    end
  end
end

class Mechanic
  def prepare_bicycle
    'air pump'
  end
end

class Clerk
  def prepare_ticket_reservation
    'ticket_reservation'
  end
end


# ----------修正後----------
# ダックタイピングを使うことで処理を共通化できる
class Trip
  def prepare(prepare_type)

    prepare_type.prepare
  end
end

class Mechanic
  def prepare
    prepare_bicycle
  end

  def prepare_bicycle
    'air pump'
  end
end

class Clerk
  def prepare
    prepare_ticket_reservation
  end

  def prepare_ticket_reservation
    'ticket_reservation'
  end
end
