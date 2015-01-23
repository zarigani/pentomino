# Pentomino

Find answer of pentomino puzzle on the board(3x20, 4x15, 5x12, 6x10, 7x9-3, 8x8-4).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pentomino'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pentomino

## Usage
````
Usage: pentomino [options] [board size(3-8)]
    -q                               Hide progress putting a piece on board.(quiet mode)

board size:
    [3] x 20
    [4] x 15
    [5] x 12
    [6] x 10 (Default)
    [7] x  9 - 3
    [8] x  8 - 4

example:
            6 x 10                        7 x 9 - 3                   8 x 8 - 4
11 12 13 14 15 16 17 18 19 1A    11 12 13 14 15 16 17 18 19    11 12 13 14 15 16 17 18
21 22 23 24 25 26 27 28 29 2A    21 22 23 24 25 26 27 28 29    21 22 23 24 25 26 27 28
31 32 33 34 35 36 37 38 39 3A    31 32 33 34 35 36 37 38 39    31 32 33 34 35 36 37 38
41 42 43 44 45 46 47 48 49 4A    41 42 43          47 48 49    41 42 43       46 47 48
51 52 53 54 55 56 57 58 59 5A    51 52 53 54 55 56 57 58 59    51 52 53       56 57 58
61 62 63 64 65 66 67 68 69 6A    61 62 63 64 65 66 67 68 69    61 62 63 64 65 66 67 68
                                 71 72 73 74 75 76 77 78 79    71 72 73 74 75 76 77 78
                                                               81 82 83 84 85 86 87 88
````
## Contributing

1. Fork it ( https://github.com/[my-github-username]/pentomino/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
