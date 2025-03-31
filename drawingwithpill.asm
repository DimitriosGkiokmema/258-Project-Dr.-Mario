################# CSC258 Assembly Final Project: Dr. Mario ###################
# This file contains our implementation of Dr Mario.
#
# Student 1: Defne Eris, 1010127596
# Student 2: Dimitrios Gkiokmema, 1010372286
#
# We assert that the code submitted here is entirely our own 
# creation, and will indicate otherwise when it is not.
#
######################## Bitmap Display Configuration ########################
# - Unit width in pixels:       4
# - Unit height in pixels:      4
# - Display width in pixels:    256
# - Display height in pixels:   256
# - Base Address for Display:   0x10008000 ($gp)
##############################################################################
##############################################################################
    .data
color_array:        .space      12
pill_array:         .space      16
ADDR_KBRD:          .word 0xffff0000
game_over:        .word 0, 0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000, 
                        0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000, 
                        0xff0000,  0,  0,  0,  0,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000, 
                        0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000, 
                        0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000, 
                        0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0, 
                        0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0, 
                        0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 
                        0xff0000,  0xff0000,  0xff0000,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0,  0xff0000, 
                        0,  0,  0,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000, 
                        0,  0,  0,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000, 
                        0,  0,  0,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000,
                        0,  0,  0,  0xff0000,  0,  0,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,
                        0,  0,  0,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0xff0000,  0xff0000,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000,  0,  0,
                        0xff0000,  0xff0000,  0xff0000,  0,  0,  0,  0,  0,  0xff0000,  0,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0,  0xff0000,  0xff0000,  0,  0,  0,  0,  0xff0000,  0xff0000,  0xff0000
dr_mario:         .word      0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x000000,     0x000000,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x000000,     0x939393,     0x7f7f7f,     0x8e8e8e,     0x1e1e1e,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x000000,     0x000000,     0x000000,     0x000000,     0x1a0905,     0x080301,     0xb8b8b8,     0x2a2a2a,     0x303030,     0x0a0a0a,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x020101,     0x251310,     0x4d2c24,     0x4d2c24,     0x4d2c24,     0x3f2019,     0x2b0f08,     0x080301,     0xb8b8b8,     0x2a2a2a,     0x959595,     0x2c2c2c,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x060201,     0x190c0a,     0x1a1a1a,     0x212121,     0x212121,     0x212121,     0x161616,     0x0f0f0f,     0x939393,     0x7f7f7f,     0x8e8e8e,     0x1e1e1e,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x040404,     0x272727,     0x4c4c4c,     0x545454,     0x212121,     0x212121,     0x161616,     0x0f0f0f,     0x000000,     0x000000,     0x0d0d0d,     0x040404,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0x1f1f1f,     0x292929,     0x1c1c1c,     0x101010,     0x251e16,     0xc2ac93,     0xcccccc,     0xcccccc,     0xbfa281,     0xcccccc,     0x565656,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0x1e1e1e,     0x121212,     0x3a211b,     0x61372e,     0xebbe8a,     0xf5dabb,     0xffffff,     0x333333,     0xf2cea4,     0x999999,     0x000000,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x251e16,     0x5f3f31,     0x61372e,     0xf5c894,     0xffdcb5,     0xffedd8,     0x84725d,     0xffd7a9,     0xc1af9b,     0x614f3a,     0x5e4c37,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x5e4c37,     0xd1a47b,     0xbf9471,     0xe0b88b,     0x66543f,     0x66543f,     0xe0b88b,     0xffd29e,     0xffd29e,     0xfacd99,     0xedc08c,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x120f0b,     0xa28360,     0xfbce9a,     0xf4c997,     0x7a644b,     0x000000,     0x282119,     0x332a1f,     0x332a1f,     0x332a1f,     0x2f261c,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x705b42,     0xeec391,     0xfbce9a,     0xfdd09c,     0x80694e,     0x2f261b,     0x2f261b,     0x1c1610,     0x000000,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x222222,     0x545454,     0x816c53,     0x8f7455,     0x94795a,     0x8d7252,     0x8d7252,     0x8d7252,     0x544431,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x1e1e1e,     0xbababa,     0xededed,     0x959595,     0x303030,     0x828282,     0x606060,     0x8d2713,     0x8d2713,     0x3a3a3a,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x333333,     0xffffff,     0xffffff,     0x545454,     0x161616,     0x8f8f8f,     0xd7d7d7,     0xd8b6b0,     0xf44a28,     0xcacaca,     0x515151,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0xdcdcdc,     0xffffff,     0xcbcbcb,     0x434343,     0xdcdcdc,     0x909090,     0x8b8b8b,     0xb8b8b8,     0xcc4529,     0x878787,     0x1d1d1d,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0xdcdcdc,     0xffffff,     0x666666,     0xa9a9a9,     0xffffff,     0xc2c2c2,     0x737373,     0x5e5e5e,     0x5e5e5e,     0xa6a6a6,     0x5b5b5b,     0x333333,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0x717171,     0xe5e5e5,     0xa8a8a8,     0x5d5d5d,     0xeaeaea,     0xffffff,     0xffffff,     0xb3b3b3,     0xb3b3b3,     0xf4f4f4,     0x5b5b5b,     0x808080,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0xd4d4d4,     0xf6f6f6,     0xe1e1e1,     0xb2b2b2,     0x4e4e4e,     0xdcdcdc,     0xf1f1f1,     0xefefef,     0xd4d4d4,     0xfbfbfb,     0x626262,     0x808080,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x000000,     0xcccccc,     0xcccccc,     0xcccccc,     0xb0b0b0,     0x424242,     0xc9c9c9,     0xcbcbcb,     0xcccccc,     0xb0b0b0,     0xbebebe,     0x434343,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x180e0c,     0x301b17,     0x261612,     0x7f726f,     0x606060,     0x4c3c39,     0x3e241f,     0x261612,     0x261612,     0x0f0907,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x3e241f,     0x8d5246,     0x683b31,     0x59322a,     0x3a211b,     0x3c231d,     0x895044,     0x844c41,     0x764339,     0x492922,     0x3a211b,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,
                             0x010101,     0x010101,     0x010101,     0x010101,     0x000000,     0x0c0706,     0x1f120f,     0x150c0a,     0x130b09,     0x130b09,     0x070403,     0x180e0c,     0x1f120f,     0x1a0f0d,     0x130b09,     0x130b09,     0x000000,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101,     0x010101
red_virus:          .word   0x000000,  0x000000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0x000000,  0x000000,  0x000000,  0x000000,  0x000000,  0xff0000,
                            0xff0000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,  0x000000,  0x000000,
                            0xff0000,  0xff0000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,
                            0x000000,  0xff0000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0x000000,  0x000000,
                            0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,
                            0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0x000000,
                            0xff0000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0x000000,  0x000000,  0x000000,
                            0xff0000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0xff0000,  0x000000,
                            0xff0000,  0x000000,  0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,  0xff0000,
                            0xff0000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0x000000,
                            0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0x000000,
                            0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0x000000,  0xff0000,
                            0x000000,  0xff0000,  0x000000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0xff0000,  0x000000,  0x000000,
                            0xff0000,  0x000000,  0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,  0x000000,
                            0x000000,  0x000000,  0xff0000,  0x000000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000,  0xff0000,  0x000000
yellow_virus:        .word  0x000000,  0x000000,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000,  0x000000,  0x000000,  0x000000,  0x000000,  0x000000,  0xffff00,
                            0xffff00,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,  0x000000,  0x000000,
                            0xffff00,  0xffff00,  0xffff00,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,
                            0x000000,  0xffff00,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0xffff00,  0x000000,  0x000000,  0x000000,
                            0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,
                            0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0x000000,
                            0xffff00,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0x000000,  0x000000,  0x000000,
                            0xffff00,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0xffff00,  0x000000,
                            0xffff00,  0x000000,  0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,  0xffff00,
                            0xffff00,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0x000000,
                            0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0x000000,
                            0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0x000000,  0xffff00,
                            0x000000,  0xffff00,  0x000000,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0xffff00,  0x000000,  0x000000,
                            0xffff00,  0x000000,  0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,  0x000000,
                            0x000000,  0x000000,  0xffff00,  0x000000,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000,  0xffff00,  0x000000
blue_virus:         .word   0x000000,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x000000,  0x000000,  0x000000,  0x000000,  0x0000ff,
                            0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x000000,  0x000000,
                            0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,
                            0x000000,  0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x000000,
                            0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,
                            0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x000000,
                            0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x000000,  0x000000,  0x000000,
                            0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,
                            0x0000ff,  0x000000,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x0000ff,
                            0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x000000,
                            0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,
                            0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x000000,  0x0000ff,
                            0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x0000ff,  0x000000,  0x000000,
                            0x0000ff,  0x000000,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x000000,
                            0x000000,  0x000000,  0x0000ff,  0x000000,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000,  0x0000ff,  0x000000
delete_virus:       .word   0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
                            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
multiple_pill_array:.space 40
block_array:        .space 24
grid:               .word 0:457     # Array of all pixels in the bottle -->changed to 457 from 456
                                    # 24 row * 19 column grid = 456 elements
                                    # Values: 0 empty spot,         In Memory:  0x0
                                    #         l pair block at left              0x6c
                                    #         r pair block at right             0x72
                                    #         u pair block up                   0x75
                                    #         d pair block below                0x64
                                    #         s single block (no pair)          0x73
                                    #         v virus                           0x76
                                    
ADDR_DSPL:          .word 0x10008000 # The address of the bitmap display.
    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main
    
main:

    #DON'T CHANGE:
      #-Any s registers
      
    #######################################################
    # Draws Container
    #######################################################
    lw $s0, ADDR_DSPL      # $t0 = base address for display
    la $s1, pill_array
    la $s2, color_array #Initializing the color array
    li $s3, 0xff0000        # $t1 = red
    li $t3, 0x00ff00        # $t2 = green
    li $s4, 0x0000ff        # $t3 = blue

    # Calculating colours, setting them to regs
    add $s5, $s3, $t3 #yellow
    addi $t6, $zero, 0xffffff #white

    sw $s3, 0($s2) #color_array[0] = red
    sw $s4, 4($s2) #color_array[1] = blue
    sw $s5, 8($s2) #color_array[2] = yellow
    
#############################
# Draws Dr Mario
#############################
DR_MARIO:
    li $t1, 96  # column number
    li $t5, 24  # row number
    la $s0, dr_mario       # Load address of image data
    lw $v1, ADDR_DSPL
    add $v1, $v1, 3720     # Address to bottom of bitmap
    jal DRAW_ARRAY
    
#############################
# Draws Red Virus
#############################    
    li $t1, 48  # column number
    li $t5, 15  # row number
    la $s0, red_virus       # Load address of image data
    lw $v1, ADDR_DSPL
    add $v1, $v1, 11040     # Address to bottom of bitmap
    jal DRAW_ARRAY

#############################
# Draws Yellow Virus
#############################    
    li $t1, 48  # column number
    li $t5, 15  # row number
    la $s0, yellow_virus       # Load address of image data
    lw $v1, ADDR_DSPL
    add $v1, $v1, 11100     # Address to bottom of bitmap
    jal DRAW_ARRAY

#############################
# Draws Blue Virus
#############################    
    li $t1, 48  # column number
    li $t5, 15  # row number
    la $s0, blue_virus       # Load address of image data
    lw $v1, ADDR_DSPL
    add $v1, $v1, 11160     # Address to bottom of bitmap
    jal DRAW_ARRAY
    
    # Deletes virus - reference later
    # li $t1, 48  # column number
    # li $t5, 15  # row number
    # la $s0, delete_virus       # Load address of image data
    # lw $v1, ADDR_DSPL
    # add $v1, $v1, 11160     # Address to bottom of bitmap
    # jal DRAW_ARRAY
    
# Reseting initial values, as DRAW_ARRAY Changed them
    lw $s0, ADDR_DSPL      # $t0 = base address for display
    la $s1, pill_array
    la $s2, color_array #Initializing the color array
    li $s3, 0xff0000        # $t1 = red
    li $t3, 0x00ff00        # $t2 = green
    li $s4, 0x0000ff        # $t3 = blue

    la $s7, block_array
    li $t1, 0x73 # $t1 = 's'
    li $t2, 0x75 # $t2 = 'u'
    li $t3, 0x64 # $t3 = 'd'
    sw $t1, 0($s7) # block_array[0] = 's'
    sw $t2, 4($s7) # block_array[1] = 'u'
    sw $t3, 8($s7) # block_array[2] = 'd'
    
    li $t1, 0x6c # $t1 = 'l'
    li $t2, 0x72 # $t1 = 'r'
    li $t3, 0x76 # $t1 = 'v'
    sw $t1, 12($s7)
    sw $t2, 16($s7)
    sw $t3, 20($s7)
    
    la $s6, grid            # $s1 holds the address of grid
    
    
    ########### Functions ##########
    ## The line drawing function ##
    # Args:
    # - $a0: X cord
    # - $a1: Y cord
    # - $a2: Length of the line
    # - $a3: direction of line
    
    ## Call below function to draw container ##
    # left entry wall
    addi $a0, $zero, 15   # X
    addi $a1, $zero, 10   # Y
    addi $a2, $zero, 3  # Length
    addi $a3, $zero, 256 # determines directions of line. 128 for vertical, 4 for horizontal
    jal initialize_and_draw
    
    # top left wall
    # No need to reset x and y, since we want them to stay the same
    addi $a2, $zero, 8  # Length
    addi $a3, $zero, -4 # direction
    jal draw_line
    
    # left wall
    addi $a2, $zero, 25  # Length
    addi $a3, $zero, 256 # direction
    jal draw_line
    
    # bottom wall
    addi $a2, $zero, 20  # Length
    addi $a3, $zero, 4   # direction
    jal draw_line
    
    # right wall
    addi $a2, $zero, 25  # Length
    addi $a3, $zero, -256 # direction
    jal draw_line
    
    # top right wall
    addi $a2, $zero, 8  # Length
    addi $a3, $zero, -4 # direction
    jal draw_line
    
    # right entry wall
    addi $a2, $zero, 4  # Length
    addi $a3, $zero, -256 # direction
    jal draw_line

    add $a2, $zero, 0
    jal Generate_Random_Virus
    add $a2, $zero, 4
    jal Generate_Random_Virus
    add $a2, $zero, 8
    jal Generate_Random_Virus
    
    addi $sp, $sp, -4
    li $t9, 450
    sw $t9, 0($sp)
    
    #li $t7, 1
    j pill_array_init    # Skips the line function, so it doesn't get called accidentally
    
    # Main line drawing loop
    initialize_and_draw:
    sll $a0, $a0, 2     # add the horizontal offset to the offset to the previous location, to get to the starting point for the line.
    sll $a1, $a1, 8      # add the vertical offset to the previous location, to get to the correct starting row. 2**7 = 128
    add $a0, $a0, $a1    # add vertical and horizontal offsets to $a0
    add $a0, $a0, $s0    # add starting address of bitmap
    
    draw_line:      # the starting label for the pixel drawing loop
    beq $a2, $zero, draw_line_end # break out of loop if stop cond is met
    # The below line ACTS LIKE MULT, by shifting the results. Mult would have needed another line of code
    sw $t6, 0( $a0 )     # paint the current bitmap location white
    addi $a2, $a2, -1    # decrement loop var
    add $a0, $a0, $a3     # move to next pixel in row
    j draw_line   # jump to the top of the loop
    draw_line_end:      # end for loop
    jr $ra

Generate_Random_Virus:
    li $v0 , 42
    li $a0 , 0
    li $a1 , 366 #generates a random number from (0,3034), stores in $a0
    syscall #needs to store the value in the bitmap/display and the array

    addi $a0, $a0, 90
    addi $t5, $s0, 3356 #access the top left block
    addi $t6, $zero, 19 #original 19
    div $a0, $t6
    mflo $t6 #row
    mfhi $t8 #column
    beq $t8, $zero, change_values_virus
  continue_generating_virus:
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 
    add $t5, $t5, $t8
    add $t5, $t5, $t6
    add $t7, $a2, $s2
    lw $t6, 0($t7) #needs to store color
    lw $t8, 0($t5)
    bne $t8, $zero, Generate_Random_Virus 
    sw $t6, 0($t5)

    addi $t5, $zero, 4
    mult $a0, $t5
    mflo $t5
    add $t5, $t5, $s6
    lw $t6, 20($s7)
    sw $t6, 0($t5)

    jr $ra

  change_values_virus:
    addi $t8, $zero, 19 
    addi $t6, $t6, -1
    j continue_generating_virus
    
# Stores all s, t, a, and v registers to the stack
store_to_stack:
    addi $sp, $sp, -92       # Allocate space for 22 registers (22 × 4 = 88)
    sw $s0, 0($sp)           # Store $s0
    sw $s1, 4($sp)           # Store $s1
    sw $s2, 8($sp)           # Store $s2
    sw $s3, 12($sp)          # Store $s3
    sw $s4, 16($sp)          # Store $s4
    sw $s5, 20($sp)          # Store $s5
    sw $s6, 24($sp)          # Store $s6
    sw $s7, 28($sp)          # Store $s7
    sw $t0, 32($sp)          # Store $t0
    sw $t1, 36($sp)          # Store $t1
    sw $t2, 40($sp)          # Store $t2
    sw $t3, 44($sp)          # Store $t3
    sw $t4, 48($sp)          # Store $t4
    sw $t5, 52($sp)          # Store $t5
    sw $t6, 56($sp)          # Store $t6
    sw $t7, 60($sp)          # Store $t7
    sw $t8, 64($sp)          # Store $t8
    sw $t9, 68($sp)          # Store $t9
    sw $v0, 72($sp)          # Store $v0
    sw $a0, 76($sp)          # Store $a0
    sw $a1, 80($sp)          # Store $a1
    sw $a2, 84($sp)          # Store $a2
    sw $a3, 88($sp)          # Store $a3
    jr $ra                   # Return

# Restores all s, t, a, and v registers from the stack
get_from_stack:
    lw $s0, 0($sp)           # Restore $s0
    lw $s1, 4($sp)           # Restore $s1
    lw $s2, 8($sp)           # Restore $s2
    lw $s3, 12($sp)          # Restore $s3
    lw $s4, 16($sp)          # Restore $s4
    lw $s5, 20($sp)          # Restore $s5
    lw $s6, 24($sp)          # Restore $s6
    lw $s7, 28($sp)          # Restore $s7
    lw $t0, 32($sp)          # Restore $t0
    lw $t1, 36($sp)          # Restore $t1
    lw $t2, 40($sp)          # Restore $t2
    lw $t3, 44($sp)          # Restore $t3
    lw $t4, 48($sp)          # Restore $t4
    lw $t5, 52($sp)          # Restore $t5
    lw $t6, 56($sp)          # Restore $t6
    lw $t7, 60($sp)          # Restore $t7
    lw $t8, 64($sp)          # Restore $t8
    lw $t9, 68($sp)          # Restore $t9
    lw $v0, 72($sp)          # Restore $v0
    lw $a0, 76($sp)          # Restore $a0
    lw $a1, 80($sp)          # Restore $a1
    lw $a2, 84($sp)          # Restore $a2
    lw $a3, 88($sp)          # Restore $a3
    addi $sp, $sp, 92        # Restore stack pointer
    jr $ra                   # Return
    
########################
# Sound Effect Functions
########################
# Plays block destruction sound
  play_block_destroy:
    addi $sp, $sp, -8
    sw $ra, 0($sp)
    sw $s0, 4($sp)
    
    # Play descending tones
    li $a0, 80   # Pitch (MIDI note)
    li $a1, 200  # Duration (ms)
    li $a2, 0    # Instrument (piano)
    li $a3, 100  # Volume
    li $v0, 31   # Syscall for tone generation
    syscall
    
    li $a0, 300  # Delay between notes
    li $v0, 32
    syscall
    
    li $a0, 75   # Second note
    li $a1, 200
    li $v0, 31
    syscall
    
    li $a0, 300
    li $v0, 32
    syscall
    
    li $a0, 70   # Third note
    li $a1, 200
    li $v0, 31
    syscall
    
    lw $ra, 0($sp)
    lw $s0, 4($sp)
    addi $sp, $sp, 8
    jr $ra

# Plays new pill sound  
play_new_pill:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Play ascending arpeggio
    li $a0, 72
    li $a1, 150
    li $a2, 0
    li $a3, 100
    li $v0, 31
    syscall
    
    li $a0, 100
    li $v0, 32
    syscall
    
    li $a0, 76
    li $a1, 150
    li $v0, 31
    syscall
    
    li $a0, 100
    li $v0, 32
    syscall
    
    li $a0, 79
    li $a1, 150
    li $v0, 31
    syscall
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

# Plays pill rotation sound
play_rotate_pill:
    addi $sp, $sp, -4
    sw $ra, 0($sp)
    
    # Short blip sound
    li $a0, 84
    li $a1, 50
    li $a2, 0
    li $a3, 100
    li $v0, 31
    syscall
    
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#############################
# Draws 'GAME OVER' and gives option to exit/restart game
#############################
GAME_OVER:
    addi $t1, $zero, 116 #column number
    addi $t5, $zero, 15 #row number
    la $s0, game_over       # Load address of image data
    lw $v1, ADDR_DSPL 
    add $v1, $v1, 11100     # Address to bottom of bitmap
    jal DRAW_ARRAY
    jal RESTART_GAME
    j exit

DRAW_ARRAY: # lw $s3, 8($s2)          # Load the colour red to $s3
    addi $t2, $zero, 0 #index 
    addi $t7, $zero, 4 #number to increment by
    j Loop

Loop:
    div $t2, $t1 #find which row and column we are
    mfhi $t8 #remainder
    mflo $t4 #result
    beq $t4, $zero, Inside #If column == 0, continue to inside of the loop
    beq $t8, $zero, increment_y #if row == 0, increment y by 1 (address by 256)

Inside:
    add $t9, $v1, $t8 # t9 = display address[i] in the current row
    add $t3, $t2, $s0 # t3 = image[i]
    lw $t3, 0($t3) #Load the value at index image[i]
    addi $t2, $t2, 4 #Increment i by 4
    sw $t3, 0($t9) #Draw a colored pixel at index display_address[i]
    j Loop #continue looping

increment_y:
    addi $v1, $v1, 256 #increment address by 1 row
    beq $t4, $t5, end_drawing #Check if we have reached the 15th row, end the program if we have
    j Inside #jump to where you were called

end_drawing:
  jr $ra
  
RESTART_GAME:                       # A key is pressed
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x72, restart          # Check if key s is pressed
    beq $a0, 0x71, exit             # Check if key q is pressed, exit if so
    j RESTART_GAME                  # Infinite loop until user restarts/ends game

restart:
    lw $a1, ADDR_DSPL
    addi $a0, $a1, 16380
    j paint_it_black
paint_it_black:
    beq $a0, $a1, main
    sw $zero, 0($a0)
    addi $a0, $a0, -4
    j paint_it_black

  pill_array_init: #address of first display 2628
    la $s4, multiple_pill_array
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 0($s4) 
    jal GENERATE_RANDOM_COLOR
    sw $v0, 4($s4) #display the second pixel
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 8($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 12($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 16($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 20($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 24($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 28($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 32($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 36($s4) 

    li $v0, 0xe06616
    addi $t9, $s0, 5084
    sw $v0, -256($t9)
    sw $v0, -252($t9)
    sw $v0, -260($t9)
    sw $v0, -4($t9)
    sw $v0, 4($t9)
    sw $v0, 252($t9)
    sw $v0, 260($t9)
    sw $v0, 512($t9)
    sw $v0, 508($t9)
    sw $v0, 516($t9)

    addi $t9, $s0, 6364
    sw $v0, -256($t9)
    sw $v0, -252($t9)
    sw $v0, -260($t9)
    sw $v0, -4($t9)
    sw $v0, 4($t9)
    sw $v0, 252($t9)
    sw $v0, 260($t9)
    sw $v0, 512($t9)
    sw $v0, 508($t9)
    sw $v0, 516($t9)

    addi $t9, $s0, 7644
    sw $v0, -256($t9)
    sw $v0, -252($t9)
    sw $v0, -260($t9)
    sw $v0, -4($t9)
    sw $v0, 4($t9)
    sw $v0, 252($t9)
    sw $v0, 260($t9)
    sw $v0, 512($t9)
    sw $v0, 508($t9)
    sw $v0, 516($t9)

    addi $t9, $s0, 8924
    sw $v0, -256($t9)
    sw $v0, -252($t9)
    sw $v0, -260($t9)
    sw $v0, -4($t9)
    sw $v0, 4($t9)
    sw $v0, 252($t9)
    sw $v0, 260($t9)
    sw $v0, 512($t9)
    sw $v0, 508($t9)
    sw $v0, 516($t9)    
    

  GENERATE_PILL:
    jal store_to_stack
    jal play_new_pill
    jal get_from_stack
    
    add $t9, $s0, 3652  # Location on bitmap of bottle mouth 
    lw $t9, 0($t9)
    bne $t9, $zero, GAME_OVER # If bottle mouth is not empty, game ends
    # The above is true, even when the pixel is empty! Why?
    
    lw $v0, 0($s4)
    sw $v0, 2628($s0)
    lw $v0, 4($s4)
    sw $v0, 2884($s0) 
    
    lw $v0, 8($s4)
    sw $v0, 5084($s0)
    lw $v0, 12($s4)
    sw $v0, 5340($s0)

    lw $v0, 16($s4)
    sw $v0, 6364($s0)
    lw $v0, 20($s4)
    sw $v0, 6620($s0)

    lw $v0, 24($s4)
    sw $v0, 7644($s0)
    lw $v0, 28($s4)
    sw $v0, 7900($s0)

    lw $v0, 32($s4)
    sw $v0, 8924($s0)
    lw $v0, 36($s4)
    sw $v0, 9180($s0)
    
    lw $v0, 8($s4)
    sw $v0, 0($s4)
    lw $v0, 12($s4)
    sw $v0, 4($s4)

    lw $v0, 16($s4)
    sw $v0, 8($s4)
    lw $v0, 20($s4)
    sw $v0, 12($s4)

    lw $v0, 24($s4)
    sw $v0, 16($s4)
    lw $v0, 28($s4)
    sw $v0, 20($s4)

    lw $v0, 32($s4)
    sw $v0, 24($s4)
    lw $v0, 36($s4)
    sw $v0, 28($s4)

    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 32($s4) 
    jal GENERATE_RANDOM_COLOR #color in v0
    sw $v0, 36($s4) 
    
    addi $a2, $s0, 2628 #assigns the location of the first byte to be passed as an argument
    add $t6, $zero, 0 #counter for the S key
    add $a3, $zero, 0
    add $t9, $zero, -4 #changed from t5 to t9,  0 to -4
   # beq $t7, 1, generate_second_pill
    j check_for_moving_blocks #detect_keyboard_input
  
  GENERATE_RANDOM_COLOR:
    li $v0 , 42
    li $a0 , 0
    li $a1 , 3 #generates a random number from (0,2), stores in $a0
    syscall 
    li $t6, 4
    mult $a0, $t6 #multiplies i by 4
    mflo $t7 #Stores 4i
    add $t8, $t7, $s2
    lw $v0, 0($t8) 
    jr $ra
  
  detect_keyboard_input:
    add $t1, $s0, 12136      # Address of bottom right pixel in container +
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    
    lw $a0, 0($sp)  # Gets sleep duration from stack
  	li $v0, 32  #sleep for $a0 ms 
  	syscall
    
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
  
  implement_gravity:
    jal Gravity  # Simulates gravity
  continue_gravity:
    blez $t9, loop_keyboard_detect #changed from t5 to t9
    blez $t1, GENERATE_PILL
  check_for_moving_blocks:
    blez $t1, delete_consecutive_blocks #number of blocks moved, changed GENERATE_PILL to delete_consecutive_blocks
    j loop_keyboard_detect
  check_for_deleted_blocks:
    addi $t3, $t3, -1
    bgez $t3, implement_gravity
  loop_keyboard_detect:
    b detect_keyboard_input
  
keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x73, respond_to_S     # Check if key s is pressed
    #addi $t9, $t6, -3               #changed from t5 to t9
    blez $t9, implement_gravity     #changed from t5 to t9
    beq $a0, 0x71, respond_to_Q     # Check if key q was pressed ---> Can add the upper letters as an extension (maybe giving them special functions?)
    beq $a0, 0x61, respond_to_A     # Check if key a is pressed
    beq $a0, 0x64, respond_to_D     # Check if key d is pressed
    beq $a0, 0x77, respond_to_W     # Check if key w is pressed
    beq $a0, 0x65, respond_to_E     # Check if key e is pressed
    beq $a0, 0x70, respond_to_P     # Check if key p is pressed
  
    li $v0, 1                       # ask system to print $a0
    syscall
  
    b implement_gravity

  add_pill_to_array:
    lw $t1, 8($s7)
    sw $t1, 40($s6)

    lw $t1, 4($s7)
    sw $t1, 116($s6)
    addi $a3, $s6, 40 #pass the value of the index in the grid array
    addi $t9, $t9, 1
    j implement_gravity
  
  respond_to_Q: #Should quit the game
  	li $v0, 10                      # Quit gracefully
  	syscall
  
  respond_to_A: #Should move the capsule to the left
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_ll_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dl_empty
    j implement_gravity

   continue_A: 
    lw $t1, 0($a2) #Store the color value in the first pixel
    sw $t1, -4($a2) #Paint the pixel on the left of first pixel
    sw $zero, 0($a2) #Paint the first pixel to black

    lw $t1, 0($a3)
    sw $t1, -4($a3)
    sw $zero, 0($a3) #change the value of the first pixel in the grid array
    
    lw $t1, 256($a2) #change the 256/252 values accordingly
    lw $t2, 16($s7) #load r
    beq $a1, $t2, rpixel_lmove
    sw $t1, 252($a2)
    sw $zero, 256($a2)
    addi $a2, $a2, -4

    lw $t1, 76($a3)
    sw $t1, 72($a3)
    sw $zero, 76($a3)
    addi $a3, $a3, -4
    
    j implement_gravity

  rpixel_lmove:
    lw $t1, 4($a2) #Store the color value in the first pixel
    sw $t1, 0($a2) #Paint the pixel on the left of first pixel
    sw $zero, 4($a2) #Paint the first pixel to black
    addi $a2, $a2, -4

    lw $t1, 4($a3)
    sw $t1, 0($a3)
    sw $zero, 4($a3) #change the value of the second pixel in the grid array
    addi $a3, $a3, -4 #fix the a3 value
    
    j implement_gravity

  check_ll_empty:
    lw $t1, -4($a2)
    bne $t1, $zero, implement_gravity
    j continue_A
  check_dl_empty:
    lw $t1, 252($a2)
    bne $t1, $zero, implement_gravity
    lw $t1, -4($a2)
    bne $t1, $zero, implement_gravity
    j continue_A
  
  respond_to_D: #Should move the capsule to the right
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_rr_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dr_empty
    j implement_gravity
    
  continue_D:
    lw $t1, 256($a2) #change the 256/252 values accordingly
    lw $t2, 16($s7) #load r
    beq $a1, $t2, rpixel_rmove
    sw $t1, 260($a2) #move bottom pixel
    sw $zero, 256($a2)

    lw $t1, 76($a3)
    sw $t1, 80($a3)
    sw $zero, 76($a3)
  
  lpixel_rmove:
    lw $t1, 0($a2) #Store the color value in the second pixel
    sw $t1, 4($a2) #Paint the pixel on the right of second pixel
    sw $zero, 0($a2) #Paint the second pixel to black
    addi $a2, $a2, 4

    lw $t1, 0($a3)
    sw $t1, 4($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, 4
    
    j implement_gravity
  
  rpixel_rmove:
    lw $t1, 4($a2)
    sw $t1, 8($a2)
    sw $zero, 4($a2) 

    lw $t1, 4($a3)
    sw $t1, 8($a3)
    sw $zero, 4($a3)
    
    j lpixel_rmove

  check_rr_empty:
    lw $t1, 8($a2)
    bne $t1, $zero, implement_gravity
    j continue_D
  
  check_dr_empty:
    lw $t1, 260($a2)
    bne $t1, $zero, implement_gravity
    lw $t1, 4($a2)
    bne $t1, $zero, implement_gravity
    j continue_D
    
  
  respond_to_E: #Should rotate the capsule by 90 degrees anti-clockwise
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_ra_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_da_empty
    j implement_gravity
    
  continue_E:
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    lw $t2, 8($s7) #load d
    beq $a1, $t2, bpixel_rotate_anti
    sw $t1, -256($a2)
    sw $zero, 4($a2)
    addi $a2, $a2, -256


    sw $zero, 4($a3)
    li $t1, 0x64 #'d'
    sw $t1, -76($a3)
    li $t1, 0x75 #'u'
    sw $t1, 0($a3)
    
    addi $a3, $a3, -76
    
    j implement_gravity
  
  bpixel_rotate_anti:
    lw $t1, 0($a2)
    sw $t1, 252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 252


    sw $zero, 0($a3)
    li $t1, 0x6c #'l'
    sw $t1, 76($a3)
    li $t1, 0x72
    sw $t1, 72($a3)
    addi $a3, $a3, 72
    
    j implement_gravity

  check_ra_empty:
    lw $t1, -256($a2)
    bne $t1, $zero, implement_gravity
    j continue_E
  check_da_empty:
    lw $t1, 252($a2)
    bne $t1, $zero, implement_gravity
    j continue_E
  
  
  respond_to_W: #Should rotate capsule by 90 degrees clockwise
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_rc_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dc_empty
    j implement_gravity
    
  continue_W:
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    lw $t2, 8($s7) #load d
    beq $t2, $a1 bpixel_rotate_clock
    lw $t1, 0($a2)
    sw $t1, -252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, -252

    sw $zero, 0($a3)
    li $t1, 0x75 # 'u'
    sw $t1, 4($a3)
    li $t1, 0x64 # 'd'
    sw $t1, -72($a3)
    addi $a3, $a3, -72
    
    j implement_gravity
  
  bpixel_rotate_clock:
    lw $t1, 0($a2)
    sw $t1, 260($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256

    sw $zero, 0($a3)
    li $t1, 0x72 # 'r'
    sw $t1, 76($a3)
    li $t1, 0x6c # 'l'
    sw $t1, 80($a3)
    addi $a3, $a3, 76
    
    j implement_gravity

  check_rc_empty:
    lw $t1, -252($a2)
    bne $t1, $zero, implement_gravity
    j continue_W
  check_dc_empty:
    lw $t1, 260($a2)
    bne $t1, $zero, implement_gravity
    j continue_W
  
  respond_to_S: #Should move the capsule to the bottom
    beq $a3, $zero, continue_S
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_rd_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dd_empty
    j implement_gravity
    
  continue_S:
    lw $t1, 4($a2)
    lw $t2, 8($s7) #load d
    beq $t2, $a1, bpixel_down
    beq $t1, $zero, bpixel_down
    sw $t1, 260($a2)
    sw $zero, 4($a2)

    lw $t2, 16($s7) #load r
    beq $a3, $zero, fpixel_down
    lw $t1, 4($a3)
    sw $t1, 80($a3)
    sw $zero, 4($a3)
  
  fpixel_down:
    lw $t1, 0($a2)
    sw $t1, 256($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256

    beq $a3, $zero, end_of_S_loop
    lw $t1, 0($a3)
    sw $t1, 76($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, 76

  end_of_S_loop:
    addi $t9, $t9, 1
    beq $t9, $zero, add_pill_to_array
    j implement_gravity
  
  bpixel_down:
    lw $t1, 256($a2)
    sw $t1, 512($a2)
    sw $zero, 256($a2)

    beq $a3, $zero, fpixel_down
    lw $t1, 76($a3)
    sw $t1, 152($a3)
    sw $zero, 76($a3)
    j fpixel_down

  check_rd_empty:
    lw $t1, 256($a2)
    bne $t1, $zero, implement_gravity
    lw $t1, 260($a2)
    bne $t1, $zero, implement_gravity
    j continue_S
  check_dd_empty:
    lw $t1, 512($a2)
    bne $t1, $zero, implement_gravity
    j continue_S

  respond_to_P:
    lw $a0, 0($t0)
    bne $a0, $zero, check_p
    
    addi $sp, $sp, -4
    sw $t9, 0($sp)
    
    # Painting pause symbol
    li $t9, 0xffffff    # Setting colour
    sw $t9, 520($s0)
    sw $t9, 776($s0)
    sw $t9, 1032($s0)
    sw $t9, 528($s0)
    sw $t9, 784($s0)
    sw $t9, 1040($s0)
    
    lw $t9, 0($sp)
    addi $sp, $sp, 4
    
    j respond_to_P
  check_p:
    lw $a0, 4($t0)                  # Load first word from keyboard
    beq $a0, 0x70, unpause_game             # Check if key q is pressed, exit if so
    j respond_to_P                  # Infinite loop until user restarts/ends game
    
  unpause_game:
    # Removing pause symbol
    li $zero, 0xffffff    # Setting colour
    sw $zero, 520($s0)
    sw $zero, 776($s0)
    sw $zero, 1032($s0)
    sw $zero, 528($s0)
    sw $zero, 784($s0)
    sw $zero, 1040($s0)
    
    j implement_gravity

Gravity:
    #addi $t9, $zero, 0
    addi $t1, $zero, 0
  
  bring_down:
    add $t4, $zero, 1748      # Max i is 456 - 24 (since we start on the second last row) elements * 4 = 1748 + bitmap address
    
  bring_down_loop:
    add $t0, $t4, $s6
    beq $t4, $zero, exit_row_loop     # $t0 is at first index, so loop must terminate
    
    # Conditionals to check if we can/should bring down a pixel
    # If bitmap pixel is 's', 'u', 'd', or 'l'
    # If column below is empty
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
    
  check_s:
    lw $t3, 0($s7)  # loads first block value from block_array: 's'
    beq $t2, $t3, check_below_row
    
  check_u:
    lw $t3, 4($s7)  # loads second block value from block_array: 'u'
    beq $t2, $t3, check_below_row
    
  check_d:
    lw $t3, 8($s7)  # loads first block value from block_array: 'd'
    beq $t2, $t3, check_below_row

  check_l:
    lw $t3, 12($s7)  # loads first block value from block_array: 'l'
    beq $t2, $t3, check_bottom_left

    j decrement


  check_bottom_left:
    lw $t2, 72($t0) # Loads the value in the grid array at [r + 1][c - 1]
              
              # [r + 1][c - 1] in this case is #t0 + 18 * 4 = $t0 + 72
    beq $t2, $zero, check_right   # [r + 1][c - 1] is empty, so we check [r + 1][c]

    # If this is reached, the above beq were false, so check_right should be skipped
    j decrement
    

  check_right:
    lw $t2, 76($t0) # Loads the value in the grid array at [r + 1][c]
                      # [r + 1][c] in this case is #t0 + 19 * 4 = $t0 + 76
    beq $t2, $zero, move_down_horizontal_pill   # [r + 1][c] is also empty, so we can move down the piece

    # If this is reached, the above beq were false, so move_down_horizontal_pill should be skipped
    j decrement


  move_down_horizontal_pill:
    lw $t2, 0($t0)
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    addi $t0, $t0, -4   # Moves index to the left so that we can move the left block down
                        # Thus, we are now at [r][c - 1]
    lw $t2, 0($t0)
    sw $t2, 76($t0)     # Stores the value of [r][c - 1] to [r + 1][c - 1]
    sw $zero, 0($t0)    # Clears the value of [r][c - 1] as we just moved it
    addi $t0, $t0, 4    # Moves index back to its original position

    addi $t5, $s0, 3356 #it does access the top left block 
    addi $t6, $zero, 4
    div $t4, $t6
    mflo $t7
    addi $t6, $zero, 19 #original 19
    div $t7, $t6
    mflo $t6 #row
    mfhi $t8 #column
    beq $t8, $zero, change_values_horizontal
  continue_move_horizontal:
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 #check sometime --> why we don't need to add 4 sideways as well
    add $t5, $t5, $t8
    add $t5, $t5, $t6

    addi $t1, $t1, 2
    jal change_as_horizontal

   continue_bring_down_for_horizontal:
    lw $t6, 0($t5)
    sw $t6, 256($t5)
    sw $zero, 0($t5)

    lw $t6, -4($t5)
    sw $t6, 252($t5)
    sw $zero, -4($t5)
    
    j decrement         # The horizontal pill has moved down
    
  check_below_row:
    lw $t2, 76($t0) # Loads the value in the grid array right below the current index
                      # [r + 1][c] in this case is #t0 + 19 * 4 = $t0 + 76
    beq $t2, $zero, move_down   # row below is empty, so we can move down the block
    
    # If this is reached, the above beq were false, so move_down should be skipped
    j decrement
    
  move_down:
    lw $t2, 0($t0)
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    
    #sub $t5, $zero, $t4 
    #add $t6, $t5, 1748 #index of element
    #add $t6, $t6, $s0
    #lw $t7, 0($t6)
    #sw $t7, 256($t6) 60 + 2560
    addi $t5, $s0, 3356 #access the top left block from display
    addi $t6, $zero, 4
    div $t4, $t6
    mflo $t7
    addi $t6, $zero, 19 #original 19
    div $t7, $t6
    mflo $t6 #row
    mfhi $t8 #column
    beq $t8, $zero, change_values
  continue_move:
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 #check sometime --> why we don't need to add 4 sideways as well
    add $t5, $t5, $t8
    add $t5, $t5, $t6

    addi $t1, $t1, 1
    beq $t5, $a2, change_as

   continue_bring_down:
    lw $t6, 0($t5)
    sw $t6, 256($t5)
    sw $zero, 0($t5)
    
  decrement:
    # Decrimenting loop variables
    # This is preparing the index value for the next iteration of the loop
    add $t4, $t4, -4        # Decrimenting array address
    
    # Loop again
    j bring_down_loop               # calls the next iteration of the outer loop
    
  exit_row_loop:
    #addi $9, $t9, 1
    #beq $t9, 1, delete_consecutive_blocks
    j continue_gravity      # Jumps to update_matrix

  change_as:
    addi $a2, $a2, 256
    beq $a3, $zero, continue_bring_down
    addi $a3, $a3, 76
    j continue_bring_down


  change_as_horizontal:
    addi $a2, $a2, 256
    beq $a3, $zero, continue_bring_down_for_horizontal
    addi $a3, $a3, 76
    jr $ra

  change_values:
    addi $t8, $zero, 19 
    addi $t6, $t6, -1
    j continue_move  
    
  change_values_horizontal:
    addi $t8, $zero, 19 
    addi $t6, $t6, -1
    j continue_move_horizontal 


#######################################################
#delete_consecutive_blocks: deletes consecutive blocks#
#######################################################

  delete_consecutive_blocks: # Used to symbolyze that everything below is for the delete function
    addi $t3, $zero, 0      # Counter to check whether any block was deleted or not
    add $t0, $s6, 1824      # Max i is 456 elements * 4 = 1824 + bitmap address, grid array --> changed to 1820
    add $t1, $s0, 9576     # This is the bitmap address of the pixel at the bottom right of the bottle, initially : 12136
    lw $t5, 0($t1)          # Loads the colour of the pixel on the bitmap at the current index
    add $t6, $t5, $zero     # Setting the previous colour equal to the current colour, as this is required for the first loop iteration
    li $t7, 18              # Sets max col index, as we start and the end of a row. A column has 19 elements, so max index is 18
    j horizontal_loop                 # Jumps to code that finds and deletes consecutive horizontal blocks
    
  horizontal_loop: 
    beq $t0, $s6, init_vertical_loop     # $t0 is at first index, so loop must terminate
    lw $t5, 0($t1)                    # Loads the current bitmap colour in $t5
    
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
    # Conditionals to check if we can/should increase the counter
    # If bitmap pixel is not empty
    # AND if colour on the bitmap is the same as the current colour
    # THEN increment the counter
    beq $t2, $zero, reset_horizontal_counter     # Checks if spot IS empty
    bne $t5, $t6, make_horizontal_counter_one       # Checks if current colour is NOT the same as the colour of the previous block checked, should make the counter 1
    
    # If this section is reached, then the current block is not empty and has the same colour as the previous block
    addi $t4, $t4, 1        # Since the conditions are met, we found another consecutive colour, so count is increased
    
    # Check is count > 4
    # If so, clear the last four blocks
    addi $t4, $t4, -3       # Subtractring 3 from counter. If still > 0, then it was >=4
    bgtz $t4, reset_horizontal_blocks   # checks to see if count >= 4
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    j horizontal_decrement  #instead of j reset_horizontal_counter to keep the counter value # If this is reached, then counter < 4 so move on to check next block
    
reset_horizontal_blocks:    # Resets the last four blocks, #t5, t8 free
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    
    # Removes blocks from GRID ARRAY
    addi $a0, $t0, 0
    addi $a1, $zero, 0
    jal create_single_blocks_horizontal
    sw $zero, 0($t0)        # Resets the value at grid[r][c]
    
    addi $a0, $t0, 4
    addi $a1, $zero, 4
    jal create_single_blocks_horizontal
    sw $zero, 4($t0)        # Resets the value at grid[r][c+ 1]

    addi $a0, $t0, 8
    addi $a1, $zero, 8
    jal create_single_blocks_horizontal
    sw $zero, 8($t0)        # Resets the value at grid[r][c + 2]

    addi $a0, $t0, 12
    addi $a1, $zero, 12
    jal create_single_blocks_horizontal
    sw $zero, 12($t0)       # Resets the value at grid[r][c + 3]
    
    # Removes blocks from BITMAP
    sw $zero, 0($t1)        # Resets the value at bitmap[r][c]
    sw $zero, 4($t1)        # Resets the value at bitmap[r][c + 1]
    sw $zero, 8($t1)        # Resets the value at bitmap[r][c + 2]
    sw $zero, 12($t1)       # Resets the value at bitmap[r][c + 3]

    #add a counter here
    addi $t3, $t3, 4
    
    sw $t9, -4($sp)         # Store current value of $t9 in stack
    lw $t9, 0($sp)
    addi $t9, $t9, -50      # Decreases sleep duration (makes game faster)
    sw $t9, 0($sp)
    lw $t9, -4($sp)         # Get back current $t9 from stack
    
    jal store_to_stack
    jal play_block_destroy
    jal get_from_stack
    
    j horizontal_decrement  # We do not want to trigger the next piece of code
                            # If triggered, only four consecutive blocks will be removed at a time
                            # However, if we skip over it now, then we allow the game to remove > 4 at a time (since counter isn't reset)
make_horizontal_counter_one:
    li $t4, 1
    j horizontal_decrement
reset_horizontal_counter: #I think there is a logical issue, should move on to the next one
    li $t4, 0       # Resets the counter to 0, as current spot in the grid array is empty
    j horizontal_decrement  # There is no block at the current index, reset count and move on to next spot in the playing field
    
horizontal_decrement:
    # Decrimenting loop variables for the delete funciton (delete_consecutive_blocks)
    # If col = 0, the bitmap address needs to be at the end of the above row
    beq $t7, $zero, horizontal_special_decrement 
    add $t1, $t1, -4    # Moves bitmap index to the left block
    j horizontal_default_decrement
horizontal_special_decrement:
    add $t1, $t1, -184    # Decrimenting bitmap address so that the next location is at the end of the row above in the bottle
    li $t4, 0        # Sets the counter to 0. This is incremented each time we find a non-empty spot on the grid
                     # As this is the end of the row, this count must be reset
    
horizontal_default_decrement:   # This will be called at EACH loop iteration, as $t0 and $t4 must always be decrimented
    # This is preparing the index value for the next iteration of the loop
    add $t0, $t0, -4        # Decrimenting array address
    add $t6, $zero, $t5     # Stores the colour of this iteration in $t6 to be used in the next iteration
    addi $t7, $t7, -1       # Decriments column index
    
    # Loop again
    j horizontal_loop       # calls the next iteration of the outer loop

 create_single_blocks_horizontal:
     #a0 is the place of the current element, a1 is the index
     lw $t5, 0($a0)
     beq $a1, $zero, check_first_pixel
     beq $a1, 12, check_last_pixel
     lw $t8, 4($s7)
     beq $t5, $t8, make_up_single
     lw $t8, 8($s7)
     beq $t5, $t8, make_down_single
  return_back:
     jr $ra

  check_last_pixel:
     lw $t8, 12($s7)
     beq $t5, $t8, return_back
     lw $t8, 4($s7)
     beq $t5, $t8, make_up_single
     lw $t8, 8($s7)
     beq $t5, $t8, make_down_single
     lw $t8, 16($s7)
     beq $t5, $t8, make_right_single
     j return_back
     
  check_first_pixel:
     lw $t8, 16($s7)
     beq $t5, $t8, return_back
     lw $t8, 4($s7)
     beq $t5, $t8, make_up_single
     lw $t8, 8($s7)
     beq $t5, $t8, make_down_single
     lw $t8, 12($s7)
     beq $t5, $t8, make_left_single
     j return_back
  make_right_single:
     lw $t5, 0($s7)
     sw $t5, 4($a0)
     j return_back
  make_left_single:
     lw $t5, 0($s7)
     sw $t5, -4($a0)
     j return_back
  make_up_single:
     lw $t5, 0($s7)
     sw $t5, -76($a0)
     j return_back

  make_down_single:
     lw $t5, 0($s7)
     sw $t5, 76($a0)
     j return_back

#########################################################
# VARIABLES:
#########################################################
# $s0 base address for display
# $s1 address for grid array
# $s2 address for block_array

# $t0 i: index of current element in the grid array. Start at end of second-last row: 1748 and i - 4 each iteration
# $t1 bitmap address: the adress of i in the bitmap (used to get the colour of the current pixel)
# $t2 value of grid[i]
# $t3 value of block from block_array we are comparing $t2 to --> not used/used for other purpuses
# $t4 count: counts the amount of consecutives blocks found * 4
#               Used for both horizontal and vertical checks, so less registers are used
# $t5 current bitmap colour: colour of the current pixel in the bitmap
# $t6 previous bitmap colour: The colour of the previous block that was checked
# $t7 row count: used to tell the index of the current row
#########################################################
############################################
# Loop to find and delete VERTICAL blocks
############################################
init_vertical_loop:
    addi $t0, $s6, 1824      # Max i is 456 elements * 4 = 1824 + bitmap address
    addi $t1, $s0, 9576     # This is the bitmap address of the pixel at the bottom right of the bottle
    lw $t5, 0($t1)          # Loads the colour of the pixel on the bitmap at the current index
    add $t6, $t5, $zero     # Setting the previous colour equal to the current colour, as this is required for the first loop iteration
    li $t7, 23              # Sets max row index, as we start and the end of a row. A column has 24 rows, so max index is 23


vertical_loop:
    beq $t0, $s6, exit_vertical_loop     # $t0 is at first index, so loop must terminate
    lw $t5, 0($t1)                    # Loads the current bitmap colour in $t5
    
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
    # Conditionals to check if we can/should increase the counter
    # If bitmap pixel is not empty
    # AND if colour on the bitmap is the same as the current colour
    # THEN increment the counter
    beq $t2, $zero, reset_vertical_counter     # Checks if spot IS empty
    bne $t5, $t6, make_vertical_counter_one       # Checks if current colour is NOT the same as the colour of the previous block checked
    
    # If this section is reached, then the current block is not empty and has the same colour as the previous block
    addi $t4, $t4, 1        # Since the conditions are met, we found another consecutive colour, so count is increased
    
    # Check is count > 4
    # If so, clear the last four blocks
    addi $t4, $t4, -3       # Subtractring 3 from counter. If still > 0, then it was >=4
    bgtz $t4, reset_vertical_blocks   # checks to see if count >= 4
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    j vertical_decrement  # If this is reached, then counter < 4 so move on to check next block
    
reset_vertical_blocks:    # Resets the last four blocks
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    
    # Removes blocks from GRID ARRAY
    addi $a0, $t0, 0
    addi $a1, $zero, 0
    jal create_single_blocks_vertical
    sw $zero, 0($t0)           # Resets the value at grid[r][c]
    
    addi $a0, $t0, 76
    addi $a1, $zero, 76
    jal create_single_blocks_vertical
    sw $zero, 76($t0)        # Resets the value at grid[r + 1][c]
  
    addi $a0, $t0, 152
    addi $a1, $zero, 152
    jal create_single_blocks_vertical
    sw $zero, 152($t0)        # Resets the value at grid[r + 2][c]
    
    addi $a0, $t0, 228
    addi $a1, $zero, 228
    jal create_single_blocks_vertical
    sw $zero, 228($t0)        # Resets the value at grid[r + 3][c]
    
    # Removes blocks from BITMAP
    sw $zero, 0($t1)        # Resets the value at bitmap[r][c]
    sw $zero, 256($t1)        # Resets the value at bitmap[r + 1][c]
    sw $zero, 512($t1)        # Resets the value at bitmap[r + 2][c]
    sw $zero, 768($t1)       # Resets the value at bitmap[r + 3][c]
    
    sw $t9, -4($sp)         # Store current value of $t9 in stack
    lw $t9, 0($sp)
    addi $t9, $t9, -50      # Decreases sleep duration (makes game faster)
    sw $t9, 0($sp)
    lw $t9, -4($sp)         # Get back current $t9 from stack
    
    jal store_to_stack
    jal play_block_destroy
    jal get_from_stack

    #Increment counter here
    addi $t3, $t3, 4
    
    j vertical_decrement  # We do not want to trigger the next piece of code
                            # If triggered, only four consecutive blocks will be removed at a time
                            # However, if we skip over it now, then we allow the game to remove > 4 at a time (since counter isn't reset)
make_vertical_counter_one:
    li $t4, 1
    j vertical_decrement
reset_vertical_counter:
    li $t4, 0       # Resets the counter to 0, as current spot in the grid array is empty
    j vertical_decrement  # There is no block at the current index, reset count and move on to next spot in the playing field
    
vertical_decrement:
    # Decrimenting loop variables for the delete funciton (delete_consecutive_blocks)
    # If row = 0, the bitmap address needs to be at the end of the above row
    beq $t7, $zero, vertical_special_decrement 
    add $t1, $t1, -256       # Decrimenting the bitmap index to [r][c + 1
    add $t0, $t0, -76        # Decrimenting array address to be at [r][c -1]
    j vertical_default_decrement
vertical_special_decrement:
    add $t1, $t1, 5884    # Incrementing bitmap address so that the next location is at the bottom of the left col
    add $t0, $t0, 1744     # Incrementing array address to be at [r + 1][c], should it be 76???
    li $t4, 0        # Sets the counter to 0. This is incremented each time we find a non-empty spot on the grid
                     # As this is the end of the row, this count must be reset
    li $t7, 24 #should also init t7 again
    
vertical_default_decrement:   # This will be called at EACH loop iteration, as $t0 and $t4 must always be decrimented
    # This is preparing the index value for the next iteration of the loop
    add $t6, $zero, $t5     # Stores the colour of this iteration in $t6 to be used in the next iteration
    addi $t7, $t7, -1       # Decriments column index
    
    # Loop again
    j vertical_loop       # calls the next iteration of the outer loop

 create_single_blocks_vertical:
     #a0 is the place of the current element, a1 is the index
     lw $t5, 0($a0)
     beq $a1, $zero, check_first_pixel_vertical
     beq $a1, 228, check_last_pixel_vertical
     lw $t8, 16($s7)
     beq $t5, $t8, make_right_single_vertical
     lw $t8, 12($s7)
     beq $t5, $t8, make_left_single_vertical
  return_back_vertical:
     jr $ra

  check_last_pixel_vertical:
     lw $t8, 4($s7)
     beq $t5, $t8, return_back_vertical
     lw $t8, 8($s7)
     beq $t5, $t8, make_down_single_vertical
     lw $t8, 16($s7)
     beq $t5, $t8, make_right_single_vertical
     lw $t8, 12($s7)
     beq $t5, $t8, make_left_single_vertical
     j return_back_vertical

     
  check_first_pixel_vertical:
     lw $t8, 8($s7)
     beq $t5, $t8, return_back_vertical
     lw $t8, 4($s7)
     beq $t5, $t8, make_up_single_vertical
     lw $t8, 12($s7)
     beq $t5, $t8, make_left_single_vertical
     lw $t8, 16($s7)
     beq $t5, $t8, make_right_single_vertical
     j return_back_vertical

  make_right_single_vertical:
     lw $t5, 0($s7)
     sw $t5, 4($a0)
     j return_back_vertical
     
  make_left_single_vertical:
     lw $t5, 0($s7)
     sw $t5, -4($a0)
     j return_back_vertical
     
  make_up_single_vertical:
     lw $t5, 0($s7)
     sw $t5, -76($a0)
     j return_back_vertical

  make_down_single_vertical:
     lw $t5, 0($s7)
     sw $t5, 76($a0)
     j return_back_vertical

    
exit_vertical_loop:
    #check if there were any deleted blocks to bring down
    j check_for_deleted_blocks

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
