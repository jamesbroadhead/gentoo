# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 ) # does not work with py3 yet

inherit autotools eutils vcs-snapshot python-single-r1

DESCRIPTION="Openstack Unix Guest Agent"
HOMEPAGE="https://github.com/rackerlabs/openstack-guest-agents-unix"
SRC_URI="https://github.com/rackerlabs/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-util/patchelf
	dev-python/pycrypto[${PYTHON_USEDEP}]
	dev-python/pyxenstore[${PYTHON_USEDEP}]"

# Fails to build if python2.5/python2.6 are present
DEPEND="${RDEPEND}
	!dev-lang/python:2.5
	!dev-lang/python:2.6
	${PYTHON_DEPS}"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/patches-1.39.0-20140621.patch \
		"${FILESDIR}"/openstack-guest-agents-unix-1.39.0-python2.patch
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install
	doinitd scripts/gentoo/nova-agent
}
