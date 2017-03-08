# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="URL shortening command line application that supports various sites"
HOMEPAGE="https://launchpad.net/surl"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV%.*}/+download/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

src_install() {
	distutils-r1_src_install

	dodoc AUTHORS || die "doc install failed"
}
