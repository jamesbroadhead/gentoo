# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# ebuild generated by hackport 0.4.2.9999

CABAL_FEATURES="bin lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Behavior-Driven Development for Haskell"
HOMEPAGE="http://hspec.github.io/"
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/ansi-terminal-0.5:=[profile?]
	>=dev-haskell/async-2:=[profile?]
	>=dev-haskell/hspec-expectations-0.5.0:=[profile?] <dev-haskell/hspec-expectations-0.5.1:=[profile?]
	>=dev-haskell/hunit-1.2.5:=[profile?]
	>=dev-haskell/quickcheck-2.5.1:2=[profile?]
	dev-haskell/quickcheck-io:=[profile?]
	dev-haskell/random:=[profile?]
	dev-haskell/setenv:=[profile?]
	dev-haskell/tf-random:=[profile?]
	>=dev-haskell/transformers-0.2.2.0:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
	test? ( >=dev-haskell/doctest-0.9.4.1
		dev-haskell/ghc-paths
		>=dev-haskell/hspec-meta-1.9.1
		>=dev-haskell/silently-1.2.4 )
"
