#!/usr/bin/python
#
# Pack BIP-39 wordlist.
#
# Copyright 2014 Mycelium SA, Luxembourg.
#
# This file is part of Mycelium Entropy.
#
# Mycelium Entropy is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.  See file GPL in the source code
# distribution or <http://www.gnu.org/licenses/>.
#
# Mycelium Entropy is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

import struct

pk = open("en-US.b39", "wb")

for word in open("en-US.txt", "r"):
    n = 0
    w = 0
    for c in word.strip():
        assert c >= 'a' and c <= 'z'
        c = ord(c) - ord('a') + 1
        w |= c << n
        n += 5
    print word.strip(), "%x" % w
    pk.write(struct.pack("<IB", w & 0xffffffff, w >> 32))

pk.close()
