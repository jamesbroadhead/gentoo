# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils flag-o-matic multilib toolchain-funcs

MY_PV=${PV//./}
SRC_URI="http://www.cs.arizona.edu/icon/ftp/packages/unix/icon-v${MY_PV}src.tgz"
HOMEPAGE="http://www.cs.arizona.edu/icon/"
DESCRIPTION="very high level language"

LICENSE="public-domain HPND"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="X iplsrc"

S="${WORKDIR}/icon-v${MY_PV}src"

DEPEND="X? ( x11-proto/xextproto
			x11-proto/xproto
			x11-libs/libX11
			x11-libs/libXpm
			x11-libs/libXt )
	|| ( sys-devel/gcc sys-devel/gcc-apple )"

PATCHES=(
	"${FILESDIR}"/${P}-flags.patch
)

src_prepare() {
	epatch "${PATCHES[@]}"

	# do not prestrip files
	find "${S}"/src -name 'Makefile' | xargs sed -i -e "/strip/d" || die
}

src_configure() {
	# select the right compile target.  Note there are many platforms
	# available
	local mytarget;
	if [[ ${CHOST} == *-darwin* ]]; then
		mytarget="macintosh"
	else
		mytarget="linux"
	fi

	if use X; then
		emake X-Configure name=${mytarget} -j1 || die
	else
		emake Configure name=${mytarget} -j1 || die
	fi

	# sanitise the Makedefs file generated by Configure
	sed -i \
		-e 's:-L/usr/X11R6/lib64::g' \
		-e 's:-L/usr/X11R6/lib::g' \
		-e 's:-I/usr/X11R6/include::g' \
		Makedefs || die "sed of Makedefs failed"

	append-flags $(test-flags -fno-strict-aliasing -fwrapv)
}

src_compile() {
	emake -j1 CC="$(tc-getCC)" CFLAGS="${CFLAGS}"
}

src_test() {
	make Samples || die "Samples failed"
	make Test || die "Test failed"
}

src_install() {
	dodir /usr
	dodir /usr/bin
	dodir /usr/$(get_libdir)

	make Install dest="${ED}/usr/$(get_libdir)/icon" || die "Make install failed"
	dosym /usr/$(get_libdir)/icon/bin/icont /usr/bin/icont
	dosym /usr/$(get_libdir)/icon/bin/iconx /usr/bin/iconx
	dosym /usr/$(get_libdir)/icon/bin/icon  /usr/bin/icon
	dosym /usr/$(get_libdir)/icon/bin/vib   /usr/bin/vib

	cd "${S}/man/man1" || die
	doman "${PN}"t.1
	doman "${PN}".1
	rm -rf "${ED}"/usr/$(get_libdir)/${PN}/man || die

	cd "${S}/doc" || die
	dodoc *.txt *.sed ../README
	# dohtml ignores all anything except .html files, no use here
	mkdir -p "${ED}"/usr/share/doc/${PF}/html
	cp -dpR *.htm *.gif *.jpg *.css "${ED}"/usr/share/doc/${PF}/html || die
	rm -rf "${ED}"/usr/$(get_libdir)/icon/{doc,README} || die

	# optional Icon Programming Library
	if use iplsrc; then
		cd "${S}" || die
		dodir /usr/$(get_libdir)/icon/ipl
		rm -fv ipl/{BuildBin,BuildExe,CheckAll,Makefile} || die
		insinto /usr/$(get_libdir)/icon
		doins -r ipl
	fi
}
