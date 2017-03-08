# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Tool that converts a PostScript type1 font into a corresponding TeX PK font"
HOMEPAGE="http://tug.org/texlive/"
SRC_URI="mirror://gentoo/texlive-${PV#*_p}-source.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~s390 ~sh ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=dev-libs/kpathsea-6.2.1"
RDEPEND="
	!<app-text/texlive-core-2010
	!app-text/ptex
	${DEPEND}"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/texlive-${PV#*_p}-source/texk/ps2pk
DOCS=( "ChangeLog" "CHANGES.type1" "README" "README.14m" "README.type1" )

src_configure() {
	econf --with-system-kpathsea
}
