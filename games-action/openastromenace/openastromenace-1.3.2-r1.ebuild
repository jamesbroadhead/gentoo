# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils cmake-utils eutils

DESCRIPTION="Modern 3D space shooter with spaceship upgrade possibilities"
HOMEPAGE="https://sourceforge.net/projects/openastromenace/"
SRC_URI="mirror://sourceforge/openastromenace/${PV}/astromenace-src-${PV}.tar.bz2"

LICENSE="GPL-3 GPL-3+ CC-BY-SA-3.0 UbuntuFontLicense-1.0 OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/freealut
	media-libs/freetype:2
	media-libs/libogg
	media-libs/libsdl[joystick,video,X]
	media-libs/libvorbis
	media-libs/openal
	virtual/glu
	virtual/opengl
	x11-libs/libXinerama"
RDEPEND=${DEPEND}

S=${WORKDIR}/AstroMenace

src_prepare() {
	default

	# no messing with CXXFLAGS please.
	sed -i -e '/-Os/d' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=("-DDATADIR=/usr/share/${PN}")

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile

	"${CMAKE_BUILD_DIR}"/AstroMenace --pack \
		--rawdata="${S}"/RAW_VFS_DATA \
		--dir=$(dirname "${CMAKE_BUILD_DIR}") || die
}

src_install() {
	newbin "${CMAKE_BUILD_DIR}"/AstroMenace "${PN}"

	insinto /usr/share/${PN}
	doins ../*.vfs

	newicon -s 128 astromenace_128.png ${PN}.png
	newicon -s 64 astromenace_64.png ${PN}.png

	dodoc ChangeLog.txt ReadMe.txt

	make_desktop_entry "${PN}" OpenAstroMenace
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
