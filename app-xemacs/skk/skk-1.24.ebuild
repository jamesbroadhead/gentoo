# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

SLOT="0"
IUSE=""
DESCRIPTION="MULE: Japanese Language Input Method"
PKG_CAT="mule"

RDEPEND="app-xemacs/viper
app-xemacs/mule-base
app-xemacs/elib
app-xemacs/xemacs-base
app-xemacs/apel
"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"

inherit xemacs-packages
