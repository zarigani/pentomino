# coding: utf-8
BROW, BCOL = 10, 6

# すべてのピース形状をPieceオブジェクトの配列に保存する
class Piece
  attr_accessor :used, :form, :loc_form, :letter

  def initialize(a, m, n, l)
    @used = false
    @form = []
    @loc_form = []
    @letter = l
    for i in (1..m)
      for j in (1..n)
        @form << [a, a.flatten.index(1)]
        a = a.transpose.reverse # rotate L
      end
      a = a.map(&:reverse) # flip LR
    end
  end
end
  
pp = [Piece.new([[0,1,0], [1,1,1], [0,1,0]], 1, 1, :X),
      Piece.new([[1,1,1], [1,0,1]]         , 1, 4, :U),
      Piece.new([[1,1,0], [0,1,1], [0,0,1]], 1, 4, :W),
      Piece.new([[1,1,0], [0,1,1], [0,1,0]], 1, 2, :F),
      Piece.new([[1,1,0], [0,1,0], [0,1,1]], 2, 2, :Z),
      Piece.new([[1,1,1], [1,1,0]],          2, 4, :P),
      Piece.new([[1,1,1,0], [0,0,1,1]],      2, 4, :N),
      Piece.new([[1,1,1,1], [0,1,0,0]],      2, 4, :Y),
      Piece.new([[1,1,1], [0,1,0], [0,1,0]], 1, 4, :T),
      Piece.new([[1,1,1,1], [1,0,0,0]],      2, 4, :L),
      Piece.new([[1,1,1], [1,0,0], [1,0,0]], 1, 4, :V),
      Piece.new([[1,1,1,1,1]],               1, 2, :I)]

pp.each_with_index do |piece, i|
  piece.form.each do |form|
    a = []
    form[0].each_with_index do |row, r|
      row.each_with_index do |col, c|
        a << r * (BCOL + 1) + c - form[1] if col == 1
      end
    end
    piece.loc_form << a
  end
end



# boardの初期化
board = Array.new((BROW + 1) * (BCOL + 1), 0)
board.each_with_index do |b, i|
  board[i] = 100 if ((i + 1) % (BCOL + 1)) == 0 || i >= ((BCOL + 1) * BROW)
end



# パズルの解を求める
def display_board(board, pp)
  $counter += 1
  puts "No. #{$counter}"
  a = []
  board.each_slice(BCOL + 1) do |line|
    a << line.reject {|i| i == 100}.map {|i| pp[i - 1].letter}
  end
  a[0..-2].transpose.each {|line| puts line.join}
  puts
end

def try_piece(board, pp, lvl)
  $try_counter += 1
  x = board.index(0)
  pp.each_with_index do |piece, i|
    next if piece.used
    piece.loc_form.each do |blocks|
      next if board[x + blocks[0]]>0 || board[x + blocks[1]]>0 || board[x + blocks[2]]>0 || board[x + blocks[3]]>0 || board[x + blocks[4]]>0
      # ピースを置く
      blocks.each {|b| board[x + b] = i + 1}
      piece.used = true
      # すべてのピースを置ききったらTrueを返す（recursiveコールの終了）
      if lvl == 11 then
        display_board(board, pp)
        # ピースを戻す
        blocks.each {|b| board[x + b] = 0}
        piece.used = false
        return
      end
      # 次のピースを試す
      try_piece(board, pp, lvl + 1)
      # ピースを戻す
      blocks.each {|b| board[x + b] = 0}
      piece.used = false
    end
  end
end

$counter = 0
$try_counter = 0
try_piece(board, pp, 0)
puts "解合計: #{$counter}"
puts "操作数: #{$try_counter}"
