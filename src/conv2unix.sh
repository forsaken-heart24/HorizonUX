#
# Copyright (C) 2025 Luna <luna.realm.io.bennett24@outlook.com>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# go fucking learn shit if you dont know what these does.

# force users to install dos2unix.
if [ -z "$(command -v dos2unix)" ]; then
    echo " - Please install dos2unix to proceed..."
    sleep 2
    exit 1
fi

# let's convert these script files.
for j in "$(find src/)"; do
    echo "$j" | grep -q .git || dos2unix "${j}"
done