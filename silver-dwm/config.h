/* See LICENSE file for copyright and license details. */

/* preferred monitor for status output */
#define STATUSMONITOR	0

/* appearance */
static const char *fonts[] = {
	"Hermit-Regular:size=12"
};
static const char dmenufont[]       = "Hermit-Regular:size=12";
static const char normbordercolor[] = "#1f222d";
static const char normbgcolor[]     = "#1f222d";
static const char normfgcolor[]     = "#9ec1d8";
static const char selbordercolor[]  = "#9ec1d8";
static const char selbgcolor[]      = "#2f3444";
static const char selfgcolor[]      = "#9ec1d8";
static unsigned int baralpha        = 0xdf;
static unsigned int borderalpha     = 0xdf;
static const unsigned int gappx     = 20;       /* gap pixel between windows */
static const unsigned int borderpx  = 0;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */

/* tagging */
static const char *tags[] = { "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  " };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      	 		      	instance     	title       		tags mask    	isfloating monitor */
	{ NULL,					NULL,	 	"/bin/sh",		0,		1,	    -1 },
	{ NULL,					NULL,	 	"ranger",		0,		1,	    -1 },
	{ "feh",				NULL,	    	NULL,			0,		1,	    -1 },
	{ "Surf",				NULL,	    	NULL,			1 << 1,		0,	    -1 },
	{ "Chromium",  	 			NULL,       	NULL,      		1 << 2,       	0,          -1 },
	{ "Google Play Music Desktop Player",	NULL,	    	NULL,			1 << 3,		1,	    -1 },
	{ "discord",	 			NULL,	    	NULL,			1 << 4,		0,	    -1 },
	{ "Evince", 	 			NULL,	    	NULL,			1 << 6,		0,	    -1 },
	{ "Gimp",     	 			NULL,       	NULL,       		1 << 7,      	0,          -1 },
	{ NULL,					NULL,    	"LibreOffice",		1 << 7,		0,	    -1 },
	{ "VirtualBox Manager", 		NULL,	    	NULL,			1 << 8,		0,	    -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ " [] ",      tile },    /* first entry is default */
	{ " [] ",      monocle },
	{ " [] ",      centeredmaster },
	{ " [] ",      centeredfloatingmaster },
	{ " [] ",      NULL },    /* no layout function means floating behavior */
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbgcolor, "-nf", normfgcolor, "-sb", "#4e8cb7", "-sf", selfgcolor, "-b", NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *rangercmd[]  = { "st", "-e", "ranger", NULL };
static const char *surfcmd[]  = { "surf", NULL };
static const char *webcmd[]  = { "chromium", NULL };
static const char *musiccmd[]  = { "gpmdp", NULL };
static const char *suspendcmd[] = { "/bin/sh", "-c", "$HOME/.scripts/suspend.sh", NULL };
static const char *shutdowncmd[] = { "/bin/sh", "-c", "$HOME/.scripts/shutdown.sh", NULL };
static const char *restartcmd[] = { "/bin/sh", "-c", "$HOME/.scripts/restart.sh", NULL };
static const char *lockcmd[] = { "/bin/sh", "-c", "$HOME/.scripts/lock.sh", NULL };

static Key keys[] = {
	/* modifier                     key        	function        argument */
	{ MODKEY,             		XK_d,      	spawn,          {.v = dmenucmd } },
	{ MODKEY,             		XK_Return, 	spawn,          {.v = termcmd } },
	{ MODKEY,             		XK_f, 	   	spawn,          {.v = rangercmd } },
	{ MODKEY,             		XK_s,      	spawn,          {.v = surfcmd } },
	{ MODKEY,             		XK_w,      	spawn,          {.v = webcmd } },
	{ MODKEY,             		XK_m,      	spawn,          {.v = musiccmd } },
	{ MODKEY|ShiftMask,             XK_b,      	togglebar,      {0} },
	{ MODKEY,                       XK_j,      	focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      	focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_i,      	incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_o,      	incnmaster,     {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_h,      	setmfact,       {.f = -0.05} },
	{ MODKEY|ShiftMask,             XK_l,      	setmfact,       {.f = +0.05} },
	{ MODKEY|ShiftMask,             XK_Return, 	zoom,           {0} },
	{ MODKEY,                       XK_Tab,    	view,           {0} },
	{ MODKEY|ShiftMask,             XK_q,      	killclient,     {0} },
	{ MODKEY|ShiftMask,             XK_t,      	setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,             XK_m,      	setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,             XK_u,      	setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ShiftMask,             XK_p,      	setlayout,      {.v = &layouts[3]} },
	{ MODKEY|ShiftMask,             XK_f,      	setlayout,      {.v = &layouts[4]} },
	{ MODKEY,                       XK_space,  	setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  	togglefloating, {0} },
	{ MODKEY,                       XK_0,      	view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      	tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  	focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, 	focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  	tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, 	tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      	0)
	TAGKEYS(                        XK_2,                      	1)
	TAGKEYS(                        XK_3,                      	2)
	TAGKEYS(                        XK_4,                      	3)
	TAGKEYS(                        XK_5,                      	4)
	TAGKEYS(                        XK_6,                      	5)
	TAGKEYS(                        XK_7,                      	6)
	TAGKEYS(                        XK_8,                      	7)
	TAGKEYS(                        XK_9,                      	8)
	{ MODKEY|ShiftMask,             XK_Home,   	quit,           {0} },
	{ MODKEY|ShiftMask,		XK_Delete, 	spawn,	   	{.v = suspendcmd } },
	{ MODKEY|ShiftMask,		XK_Insert, 	spawn,	   	{.v = restartcmd } },
	{ MODKEY|ShiftMask,		XK_End,	   	spawn,	   	{.v = shutdowncmd } },
	{ MODKEY|ShiftMask,		XK_x,	   	spawn,	   	{.v = lockcmd } },
};

/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

