# 「Java言語で学ぶデザインパターン入門」をrubyに書き換え

# Strategyパターン
# - サンプルソース：じゃんけん
# - Playerの戦略をStrategyクラスに実装
# - 複雑なアルゴリズムをStrategyクラスに分けることで
#   - アルゴリズムの切り替えが簡単（保守しやすい）
#   - 分岐処理を書かなくて良い
#   - クラスの見通しがよくなる

# -----------コード-----------
class Hand
  # じゃんけんの手を表す定数
  ROCK = {name: "グー", hand_value: 0}
  SCISSORS = {name: "チョキ", hand_value: 1}
  PAPER = {name: "パー", hand_value: 2}
  PATTERN = [ROCK, SCISSORS, PAPER]

  attr_reader :name, :hand_value

  def initialize(arg)
    @name = arg[:name]
    @hand_value = arg[:hand_value]
  end

  def self.get_hand(hand_value)
    PATTERN[hand_value]
  end

  # selfがpair_handより強いときはtrue
  def is_stronger_than(pair_hand)
    fight(pair_hand) == 1
  end

  # selfがpair_handより弱いときはtrue
  def is_weaker_than(pair_hand)
    fight(pair_hand) == -1
  end

  # 引き分けは0,selfの勝ちは1,pair_handの勝ちは-1
  def fight(pair_hand)
    if self == pair_hand
      0
    elsif (@hand_value + 1) % 3 == pair_hand.hand_value
      1
    else
      -1
    end
  end
end

# Strategyインターフェイス
# じゃんけんの「戦略」のための抽象メソッド
class Strategy
  # 次に出す手を決める
  def next_hand; end
  # さっき出した手によって勝ったかどうかを学習する
  def study(win); end
end

# Strategyインターフェイスの実装クラス
# じゃんけんの具体的な「戦略」のためのメソッド
# 戦略：
# - 勝った場合→次も同じ手を出す
# - 負けた場合→ランダムな手を出す
class WinningStrategy < Strategy
  attr_accessor :won, :prev_hand

  def initialize
    @won = false
    @prev_hand = nil
  end

  def next_hand
    if !@won
      @prev_hand = Hand.get_hand(rand(0..2))
    end
    @prev_hand
  end

  def study(win)
    @won = win
  end
end

# Strategyインターフェイスの実装クラス
# じゃんけんの具体的な「戦略」のためのメソッド
# 戦略：
# - 過去の勝ち負けの履歴を使って、次に出す手を考える
class ProbStrategy
  attr_accessor :prev_hand_value, :current_hand_value, :history

  def initialize
    @current_hand_value = 0
    @prev_hand_value = 0
    @history = [ [1,1,1], [1,1,1], [1,1,1] ]
  end

  def next_hand
    bet = rand(1..get_sum(@current_hand_value))
    hand_value = 0

    if bet > history[current_hand_value][0]
      hand_value = 0
    elsif bet < history[current_hand_value][0] + history[current_hand_value][1]
      hand_value = 1
    else
      hand_value = 2
    end

    @prev_hand_value = @current_hand_value
    @current_hand_value = hand_value
    Hand.get_hand(hand_value)
  end

  def get_sum(hand_value)
    sum = 0
    i = 0

    while i < 3 do
      sum += @history[hand_value][i]
      i += 1
    end

    sum
  end

  def study(win)
    if win
      @history[prev_hand_value][current_hand_value] += 1
    else
      @history[prev_hand_value][(current_hand_value + 1) % 3] += 1
      @history[prev_hand_value][(current_hand_value + 2) % 3] += 1
    end
  end
end

# Strategyインターフェイスの実装クラス
# じゃんけんの具体的な「戦略」のためのメソッド
# 戦略：
# - でたらめな手を出す
class RandomStrategy
  def next_hand
    Hand.get_hand(rand(0..2))
  end
end

class Player
  # 名前と戦略を授けてプレイヤーを作る
  def initialize(name, strategy)
    @name = name
    @strategy = strategy
    @win_count  = 0
    @lose_count = 0
    @game_count = 0
  end

  # 戦略にお伺いをたてて次の手を決める
  def next_hand
    @strategy.next_hand
  end

  def win
    @strategy.study(true)
    @win_count += 1
    @game_count += 1
  end

  def lose
    @strategy.study(false)
    @lose_count += 1
    @game_count += 1
  end

  def even
    @game_count += 1
  end
end

# 実行コード
player1 = Player.new("Taro", WinningStrategy.new)
player2 = Player.new("Hana", ProbStrategy.new)

100.times do |i|
  next_hand1 = Hand.new(player1.next_hand)
  next_hand2 = Hand.new(player2.next_hand)

  if next_hand1.is_stronger_than(next_hand2)
    puts "winner 1"
    player1.win
    player2.lose

  elsif next_hand2.is_stronger_than(next_hand1)
    puts "winner 2"
    player1.lose
    player2.win
  else
    puts "even"
    player1.even
    player2.even
  end
end

puts "total_1 #{player1}"
puts "total_2 #{player2}"