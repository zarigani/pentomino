#!/usr/bin/ruby
# coding: utf-8

require 'optparse'

# オプション解析
$options = {}
OptionParser.new do |opt|
  opt.banner = 'Usage: pentomino [options] [board size(3-8)]'
  opt.on('-q', 'Hide progress putting a piece on board.(quiet mode)') {|v| $options[:quiet] = v}
  opt.separator('')
  opt.on('board size:',
         '    [3] x 20',
         '    [4] x 15',
         '    [5] x 12',
         '    [6] x 10 (Default)',
         '    [7] x  9 - 3',
         '    [8] x  8 - 4',
         )
  opt.separator('')
  opt.on('example:',
         '            6 x 10                        7 x 9 - 3                   8 x 8 - 4',
         '11 12 13 14 15 16 17 18 19 1A    11 12 13 14 15 16 17 18 19    11 12 13 14 15 16 17 18',
         '21 22 23 24 25 26 27 28 29 2A    21 22 23 24 25 26 27 28 29    21 22 23 24 25 26 27 28',
         '31 32 33 34 35 36 37 38 39 3A    31 32 33 34 35 36 37 38 39    31 32 33 34 35 36 37 38',
         '41 42 43 44 45 46 47 48 49 4A    41 42 43          47 48 49    41 42 43       46 47 48',
         '51 52 53 54 55 56 57 58 59 5A    51 52 53 54 55 56 57 58 59    51 52 53       56 57 58',
         '61 62 63 64 65 66 67 68 69 6A    61 62 63 64 65 66 67 68 69    61 62 63 64 65 66 67 68',
         '                                 71 72 73 74 75 76 77 78 79    71 72 73 74 75 76 77 78',
         '                                                               81 82 83 84 85 86 87 88',
         )
  begin
    opt.parse!(ARGV)
    BCOL = (ARGV[0] || 6).to_i
    BROW = (60.0 / BCOL).round
    raise "Invalid board size: #{BCOL}" if BCOL < 3 || 8 < BCOL
  rescue => e
    puts e
    exit
  end
end



# すべてのピース形状をPieceオブジェクトの配列に保存する
class Piece
  attr_accessor :used, :form, :loc_form, :letter, :color

  def initialize(a, m, n, l, c)
    @used = false
    @form = []
    @loc_form = []
    @letter = l
    @color = c
    for i in (1..m)
      for j in (1..n)
        @form << [a, a.flatten.index(1)]
        a = a.transpose.reverse # rotate L
      end
      a = a.map(&:reverse) # flip LR
    end
  end
end

r = BCOL == 8 ? 1 : 2
pp = [Piece.new([[0,1,0], [1,1,1], [0,1,0]], 1, 1, :X, 141),
      Piece.new([[1,1,1], [1,0,1]]         , 1, 4, :U,   6),
      Piece.new([[1,1,0], [0,1,1], [0,0,1]], 1, 4, :W, 104),
      Piece.new([[1,1,0], [0,1,1], [0,1,0]], 1, r, :F, 172),
      Piece.new([[1,1,0], [0,1,0], [0,1,1]], 2, 2, :Z, 211),
      Piece.new([[1,1,1], [1,1,0]],          2, 4, :P,  70),
      Piece.new([[1,1,1,0], [0,0,1,1]],      2, 4, :N, 121),
      Piece.new([[1,1,1,1], [0,1,0,0]],      2, 4, :Y, 170),
      Piece.new([[1,1,1], [0,1,0], [0,1,0]], 1, 4, :T,  42),
      Piece.new([[1,1,1,1], [1,0,0,0]],      2, 4, :L,   3),
      Piece.new([[1,1,1], [1,0,0], [1,0,0]], 1, 4, :V,  75),
      Piece.new([[1,1,1,1,1]],               1, 2, :I, 217)]

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

BLOCK_COLOR = [250] + pp.map{|i| i.color} + [0]



# boardの初期化
board = Array.new((BROW + 1) * (BCOL + 1), 0)
board.each_with_index do |b, i|
  board[i] = 100 if ((i + 1) % (BCOL + 1)) == 0 || i >= ((BCOL + 1) * BROW)
end
board[30], board[31], board[39], board[40] = 13, 13, 13, 13 if BCOL == 8
board[27], board[35], board[43]            = 13, 13, 13     if BCOL == 7



# エスケープシーケンス定義
def home        ; "\e[H"            ; end # カーソル位置を画面左上へ移動（ホームポジション）
def clear(n=2)  ; "\e[#{n}J"        ; end # n=(0:画面先頭からカーソル位置まで消去, 1:カーソル位置から画面末尾まで消去, 2:画面全体を消去)
def moveup(n)   ; "\e[#{n}A"        ; end # カーソルを上方向へn行移動
def bgcolor(nnn); "\e[48;5;#{nnn}m" ; end # 色指定の開始（nnn=0..255）
def reset       ; "\e[m"            ; end # 色指定の終了

# 出力コード生成
def create_block(color); bgcolor(BLOCK_COLOR[color]) + "  " + reset; end
def reset_screen       ; home + clear                              ; end
def next_screen        ; "\n" * (BCOL + 2)                         ; end

# boardを表示
def display_board(board, pp, title='')
  puts moveup(BCOL + 1) + title
  a = []
  board.each_slice(BCOL + 1) do |line|
    a << line.reject {|i| i == 100}.map {|i| create_block(i)}
  end
  a[0..-2].transpose.each {|line| puts line.join}
end

# パズルの解を求める
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
      display_board(board, pp) if !$options[:quiet]
      # すべてのピースを置ききったらTrueを返す（recursiveコールの終了）
      if lvl == 11 then
        $counter += 1
        display_board(board, pp, "No. #{$counter} (TRY: #{$try_counter})")
        puts next_screen
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
puts reset_screen
try_piece(board, pp, 0)
puts "解合計: #{$counter}"
puts "操作数: #{$try_counter}"
