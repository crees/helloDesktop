PORTNAME=	helloSystem
PORTVERSION=	0.8.1
DISTVERSIONPREFIX=	r
CATEGORIES=	sysutils

MAINTAINER=	crees@FreeBSD.org
COMMENT=	Supporting components for Hello System

LICENSE=	BSD3CLAUSE

USES=		desktop-file-utils
USE_GITHUB=	yes
GH_ACCOUNT=	helloSystem
GH_PROJECT=	ISO
NO_BUILD=	yes
WRKSRC_SUBDIR=	overlays/uzip
OVERLAYS=	hello localize openbox-theme mountarchive automount \
		xapp-thumbnailers epub-thumbnailer furybsd-settings \
		furybsd-live-settings initgfx

post-patch:
	for f in $$(${FIND} ${WRKSRC} -type f -path '*/etc/*' -and -not -path '*.d*'); do \
	    ${MV} $$f $$f.hellopkg; \
	done
	${RM} ${WRKSRC}/hello/files/.hidden
.for p in ${OVERLAYS}
	${MV} ${WRKSRC}/$p/files/usr/local ${WRKSRC}/$p/_prefix
.endfor

do-install:
	${MKDIR} ${STAGEDIR}${PREFIX}
.for p in ${OVERLAYS}
	(cd ${INSTALL_WRKSRC}/$p/files && \
		${COPYTREE_SHARE} . ${STAGEDIR} '-not -name .gitkeep' && \
		${FIND} . -type f -and -not -name .gitkeep | ${SED} 's,^\.,,' >> ${TMPPLIST} && \
		${FIND} . -type d | ${SED} -ne '\,^./usr/share/skel,s,^.,@dir ,p' >> ${TMPPLIST})
	if [ -d ${INSTALL_WRKSRC}/$p/_prefix ]; then \
		(cd ${INSTALL_WRKSRC}/$p/_prefix && \
		${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX} && \
		${FIND} . -type f | ${SED} 's,^\.,${PREFIX},' >> ${TMPPLIST}); \
	    fi
.endfor
	<${TMPPLIST} (while read f; do \
	    orig="$${f%.hellopkg}"; \
	    if [ "$$orig" != "$$f" ]; then \
		${ECHO_CMD} "@postunexec [ ! -f $$orig.original ] || mv $$orig.original $$orig"; \
		${ECHO_CMD} "@postexec [ ! -f $$orig ] || mv $$orig $$orig.original && cp $$f $$orig"; \
	    fi; \
	done) >> ${TMPPLIST}
	${ECHO_CMD} '@dir /Applications' >> ${TMPPLIST}
	${ECHO_CMD} '@dir /System' >> ${TMPPLIST}

.include <bsd.port.mk>
