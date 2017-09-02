unit oleacc;

Interface

uses Variants,classes,windows;

const
 ACCDLL='OLEACC.DLL';

const
// PROPRIETES:  Hierarchie
 DISPID_ACC_PARENT                   =-5000;
 DISPID_ACC_CHILDCOUNT               =-5001;
 DISPID_ACC_CHILD                    =-5002;

// PROPRIETES:  Description
 DISPID_ACC_NAME                     =-5003;
 DISPID_ACC_VALUE                    =-5004;
 DISPID_ACC_DESCRIPTION              =-5005;
 DISPID_ACC_ROLE                     =-5006;
 DISPID_ACC_STATE                    =-5007;
 DISPID_ACC_HELP                     =-5008;
 DISPID_ACC_HELPTOPIC                =-5009;
 DISPID_ACC_KEYBOARDSHORTCUT         =-5010;
 DISPID_ACC_FOCUS                    =-5011;
 DISPID_ACC_SELECTION                =-5012;
 DISPID_ACC_DEFAULTACTION            =-5013;

// METHODES
 DISPID_ACC_SELECT                   =-5014;
 DISPID_ACC_LOCATION                 =-5015;
 DISPID_ACC_NAVIGATE                 =-5016;
 DISPID_ACC_HITTEST                  =-5017;
 DISPID_ACC_DODEFAULTACTION          =-5018;





//  CONSTANTES

//
// Entrées de DISPID_ACC_NAVIGATE
//
const
 NAVDIR_MIN                      =$00000000;  // min
 NAVDIR_UP                       =$00000001;  // haut
 NAVDIR_DOWN                     =$00000002;  // bas
 NAVDIR_LEFT                     =$00000003;  // gauche
 NAVDIR_RIGHT                    =$00000004;  // droite
 NAVDIR_NEXT                     =$00000005;  // suivant
 NAVDIR_PREVIOUS                 =$00000006;  // précédent
 NAVDIR_FIRSTCHILD               =$00000007;  // premier enfant
 NAVDIR_LASTCHILD                =$00000008;  // dernier enfant
 NAVDIR_MAX                      =$00000009;  // max

// Entrées de DISPID_ACC_SELECT
 SELFLAG_NONE                    =$00000000;
 SELFLAG_TAKEFOCUS               =$00000001;
 SELFLAG_TAKESELECTION           =$00000002;
 SELFLAG_EXTENDSELECTION         =$00000004;
 SELFLAG_ADDSELECTION            =$00000008;
 SELFLAG_REMOVESELECTION         =$00000010;
 SELFLAG_VALID                   =$0000001F;

// Sorties de DISPID_ACC_STATE
 STATE_SYSTEM_UNAVAILABLE        =$00000001; //non disponible
 STATE_SYSTEM_SELECTED           =$00000002; //sélectionné
 STATE_SYSTEM_FOCUSED            =$00000004; //actif
 STATE_SYSTEM_PRESSED            =$00000008; //enfoncé
 STATE_SYSTEM_CHECKED            =$00000010; //coché
 STATE_SYSTEM_MIXED              =$00000020; //mélangé
 STATE_SYSTEM_READONLY           =$00000040; //lecture seule
 STATE_SYSTEM_HOTTRACKED         =$00000080; //suivi attentivement
 STATE_SYSTEM_DEFAULT            =$00000100; //par défaut
 STATE_SYSTEM_EXPANDED           =$00000200; //développé
 STATE_SYSTEM_COLLAPSED          =$00000400; //réduit
 STATE_SYSTEM_BUSY               =$00000800; //occupé
 STATE_SYSTEM_FLOATING           =$00001000; //flottant
 STATE_SYSTEM_MARQUEED           =$00002000; //défilant
 STATE_SYSTEM_ANIMATED           =$00004000; //animé
 STATE_SYSTEM_INVISIBLE          =$00008000; //invisible
 STATE_SYSTEM_OFFSCREEN          =$00010000; //en dehors de l'écran
 STATE_SYSTEM_SIZEABLE           =$00020000; //pouvant être dimensionné
 STATE_SYSTEM_MOVEABLE           =$00040000; //pouvant être déplacé
 STATE_SYSTEM_SELFVOICING        =$00080000; //vocalisation propre
 STATE_SYSTEM_FOCUSABLE          =$00100000; //pouvant être actif
 STATE_SYSTEM_SELECTABLE         =$00200000; //pouvant être sélectionné
 STATE_SYSTEM_LINKED             =$00400000; //lié
 STATE_SYSTEM_TRAVERSED          =$00800000; //traversé
 STATE_SYSTEM_MULTISELECTABLE    =$01000000; //permettant les sélections multiples
 STATE_SYSTEM_EXTSELECTABLE      =$02000000; //permettant les sélections étendues
 STATE_SYSTEM_ALERT_LOW          =$04000000; //alerte basse
 STATE_SYSTEM_ALERT_MEDIUM       =$08000000; //alerte moyenne
 STATE_SYSTEM_ALERT_HIGH         =$10000000; //alerte haute
 STATE_SYSTEM_VALID              =$1FFFFFFF; //valide

// Sorties de DISPID_ACC_ROLE
 ROLE_SYSTEM_TITLEBAR            =$00000001;    //barre de titre
 ROLE_SYSTEM_MENUBAR             =$00000002;	//barre de menus
 ROLE_SYSTEM_SCROLLBAR           =$00000003;	//barre de défilement
 ROLE_SYSTEM_GRIP                =$00000004;	//poignée
 ROLE_SYSTEM_SOUND               =$00000005;	//son
 ROLE_SYSTEM_CURSOR              =$00000006;	//curseur
 ROLE_SYSTEM_CARET               =$00000007;	//point d'insertion
 ROLE_SYSTEM_ALERT               =$00000008;	//alerte
 ROLE_SYSTEM_WINDOW              =$00000009;	//fenêtre
 ROLE_SYSTEM_CLIENT              =$0000000A;	//client
 ROLE_SYSTEM_MENUPOPUP           =$0000000B;	//menu contextuel
 ROLE_SYSTEM_MENUITEM            =$0000000C;	//élément de menu
 ROLE_SYSTEM_TOOLTIP             =$0000000D;	//astuce
 ROLE_SYSTEM_APPLICATION         =$0000000E;	//application
 ROLE_SYSTEM_DOCUMENT            =$0000000F;	//document
 ROLE_SYSTEM_PANE                =$00000010;	//volet
 ROLE_SYSTEM_CHART               =$00000011;	//graphe
 ROLE_SYSTEM_DIALOG              =$00000012;	//boîte de dialogue
 ROLE_SYSTEM_BORDER              =$00000013;	//bordure
 ROLE_SYSTEM_GROUPING            =$00000014;	//groupement
 ROLE_SYSTEM_SEPARATOR           =$00000015;	//séparateur
 ROLE_SYSTEM_TOOLBAR             =$00000016;	//barre d'outils
 ROLE_SYSTEM_STATUSBAR           =$00000017;	//barre d'état
 ROLE_SYSTEM_TABLE               =$00000018;	//tableau
 ROLE_SYSTEM_COLUMNHEADER        =$00000019;	//en-tête de colonne
 ROLE_SYSTEM_ROWHEADER           =$0000001A;	//en-tête de ligne
 ROLE_SYSTEM_COLUMN              =$0000001B;	//colonne
 ROLE_SYSTEM_ROW                 =$0000001C;	//ligne
 ROLE_SYSTEM_CELL                =$0000001D;	//cellule
 ROLE_SYSTEM_LINK                =$0000001E;	//lien
 ROLE_SYSTEM_HELPBALLOON         =$0000001F;	//bulle d'aide
 ROLE_SYSTEM_CHARACTER           =$00000020;	//personnage
 ROLE_SYSTEM_LIST                =$00000021;	//liste
 ROLE_SYSTEM_LISTITEM            =$00000022;	//élément de liste
 ROLE_SYSTEM_OUTLINE             =$00000023;	//arborescence
 ROLE_SYSTEM_OUTLINEITEM         =$00000024;	//élément d'arborescence
 ROLE_SYSTEM_PAGETAB             =$00000025;	//onglet
 ROLE_SYSTEM_PROPERTYPAGE        =$00000026;	//page de propriétés
 ROLE_SYSTEM_INDICATOR           =$00000027;	//indicateur
 ROLE_SYSTEM_GRAPHIC             =$00000028;	//image
 ROLE_SYSTEM_STATICTEXT          =$00000029;	//texte
 ROLE_SYSTEM_TEXT                =$0000002A;	//texte modifiable
 ROLE_SYSTEM_PUSHBUTTON          =$0000002B;	//bouton poussoir
 ROLE_SYSTEM_CHECKBUTTON         =$0000002C;	//case à cocher
 ROLE_SYSTEM_RADIOBUTTON         =$0000002D;	//case d'option
 ROLE_SYSTEM_COMBOBOX            =$0000002E;	//zone de liste modifiable
 ROLE_SYSTEM_DROPLIST            =$0000002F;	//liste déroulante
 ROLE_SYSTEM_PROGRESSBAR         =$00000030;	//barre de progression
 ROLE_SYSTEM_DIAL                =$00000031;	//bouton rotatif
 ROLE_SYSTEM_HOTKEYFIELD         =$00000032;	//champ de touche de raccourci clavier
 ROLE_SYSTEM_SLIDER              =$00000033;    //potentiomètre
 ROLE_SYSTEM_SPINBUTTON          =$00000034;    //zone de sélection numérique
 ROLE_SYSTEM_DIAGRAM             =$00000035;    //diagramme
 ROLE_SYSTEM_ANIMATION           =$00000036;    //animation
 ROLE_SYSTEM_EQUATION            =$00000037;    //équation
 ROLE_SYSTEM_BUTTONDROPDOWN      =$00000038;    //bouton de liste déroulante
 ROLE_SYSTEM_BUTTONMENU          =$00000039;    //bouton de menu
 ROLE_SYSTEM_BUTTONDROPDOWNGRID  =$0000003A;    //bouton de liste déroulante de grille
 ROLE_SYSTEM_WHITESPACE          =$0000003B;    //espace forcé
 ROLE_SYSTEM_PAGETABLIST         =$0000003C;	//liste d'onglets
 ROLE_SYSTEM_CLOCK               =$0000003D;	//horloge



////////////////////////////////////////////////////////////////////////////
//  definition Accessible
//
//  GUID de IAccessible interface.

const
LIBID_Accessibility: TGUID = '{1ea4dbf0-3c3b-11cf-810c-00aa00389b71}';
IID_IAccessible:     TGUID = '{618736e0-3c3d-11cf-810c-00aa00389b71}';
IID_IDispatch:       TGUID = '{a6ef9860-c720-11d0-9337-00a0c90dcaa9}';
IID_IEnumVARIANT:    TGUID = '{00020404-0000-0000-c000-000000000046}';

{$EXTERNALSYM IEnumVariant}
type
IEnumVariant = interface(IUnknown)
   ['{00020404-0000-0000-C000-000000000046}']
   function Next(celt: LongWord; var rgvar : Variant;  out pceltFetched: LongWord): HResult; stdcall;
   function Skip(celt: LongWord): HResult; stdcall;
   function Reset: HResult; stdcall;
   function Clone(out Enum: IEnumVariant): HResult; stdcall;
end;




// déclaration de IAccessible interface
type
 IAccessible=interface;
 LPACCESSIBLE=^IAccessible;
 LPDispatch=^IDispatch;

 IAccessible=interface(IDispatch)
   ['{618736e0-3c3d-11cf-810c-00aa00389b71}']
    function get_accParent(var ppdispParent:IDispatch):HRESULT; stdcall;
    function get_accChildCount(var pChildCount:longint):HRESULT;stdcall;
    function get_accChild(ChildIndex:variant;ppdispParent:LPDispatch):HRESULT;stdcall;
    function get_accName(varChild:variant;var szName:pwidechar):HRESULT;stdcall;
    function get_accValue(varChild:variant;var szValue:pwidechar):HRESULT;stdcall;
    function get_accDescription(varChild:variant;var szDescription:pwidechar):HRESULT;stdcall;
    function get_accRole(varChild:variant;var varRole:variant):HRESULT;stdcall;
    function get_accState(varChild:variant;var varState:variant):HRESULT;stdcall;
    function get_accHelp(varChild:variant;var szHelp:pwidechar):HRESULT;stdcall;
    function get_accHelpTopic(var szHelpFile:pwidechar;varChild:variant;var pidTopic:longint):HRESULT;stdcall;
    function get_accKeyboardShortcut(varChild:variant;var szKeyboardShortcut:pwidechar):HRESULT;stdcall;
    function get_accFocus(var varFocusChild:variant):HRESULT;stdcall;
    function get_accSelection(var varSelectedChildren:variant):HRESULT;stdcall;
    function get_accDefaultAction(varChild:variant;var szDefaultAction:pwidechar):HRESULT;stdcall;

    function accSelect(flagsSelect:longint;varChild:variant):HRESULT;stdcall;
    function accLocation(var pxLeft,pyTop,pcxWidth,pcyHeight:longint;varChild:variant):HRESULT;stdcall;
    
    function accNavigate(const navDir:longint;varStart:variant;varEnd:pvariant):HRESULT;stdcall;
    //navDir : Specifie la direction de navigation. Cette direction est un ordre spatial,
    //         tel NAVDIR_LEFT ou NAVDIR_RIGHT, ou un ordre logique, tel NAVDIR_NEXT
    //         ou NAVDIR_PREVIOUS.
    //varStart: Specifie si l'objet de départ de la navigation est l'object lui-même ou
    //          un des objets enfants. Ce paramêtre est soit CHILDID_SELF  (pour
    //          démarrer de l'objet) ou un numéro d'enfant (pour démarrer d'un des
    //          objets enfants)
    //varEnd:   Addresse d'une structure VARIANT qui recevera les informations de l'objet
    //          destination. La table suivante décrit les informations retournées dans varEnd
    //vartype(varend) | description
    //VarEMPTY        | rien. il n'y a pas d'élèment dans la direction spécifiée.
    //VarINTEGER      | varend contient le numéro de l'objet dans la direction spécifiée.
    //VarDISPATCH     | varend contains une addresse sur une interface IDispatch de l'objet.


    function accHitTest(xLeft,yTop:longint;var pvarChildAtPoint:variant):HRESULT;stdcall;
    function accDoDefaultAction(varChild:variant):HRESULT;stdcall;

    function put_accName(varChild:variant;szName:pwidechar):HRESULT;stdcall;
    function put_accValue(varChild:variant;pszValue:pwidechar):HRESULT;stdcall;

  end;// end interface




////////////////////////////////////////////////////////////////////////////
//  Types pour aider les liens dynamiques avec OLEACC.DLL

type
  LPFNLresultFromObject=function (riid:TGUID;wParam:WPARAM;pAcc:LPACCESSIBLE):HRESULT;stdcall;
  LPFNObjectFromLresult=function (lResult:LRESULT;riid:TGUID;wParam:WPARAM;ppvObject:LPACCESSIBLE):HRESULT;stdcall;
  LPFNAccessibleObjectFromWindow=function (wnd:HWND;dwId:DWORD;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;
  LPFNAccessibleObjectFromPoint=function (ptScreen:TPOINT;pAcc:LPACCESSIBLE;var pvarChild:variant):HRESULT;stdcall;
  LPFNCreateStdAccessibleObject=function (wnd:HWND;idObject:longint;riid:TGUID;ppvObject:LPACCESSIBLE):HRESULT;stdcall;
  LPFNAccessibleChildren=function  (paccContainer:LPAccessible;iChildStart,cChildren:longint;
                                    rgvarChildren:pvariant;var pcObtained:longint):HRESULT;stdcall;


// autres fonctions or IAccessible déclaré dans OLEACC.DLL

function GetOleaccVersionInfo(pdwVer,pdwBuild:pdword):HRESULT;stdcall;
function LresultFromObject(riid:TGUID;wParam:WPARAM;pAcc:LPACCESSIBLE):HRESULT;stdcall;
function ObjectFromLresult(lResult:LRESULT;riid:TGUID;wParam:WPARAM;ppvObject:LPACCESSIBLE):HRESULT;stdcall;
function WindowFromAccessibleObject(pAcc:IACCESSIBLE;var phwnd:HWND):HRESULT;stdcall;
function AccessibleObjectFromWindow(hWnd:HWnd;dwId:DWord;const riid:TGUID;var ppvObject:pointer):HRESULT;stdcall;
function AccessibleObjectFromEvent(wnd:HWND;dwId:DWORD;dwChildId:DWORD;pAcc:LPACCESSIBLE;var pvarChild:variant):HRESULT;stdcall;
function AccessibleObjectFromPoint(ptScreen:TPOINT;pAcc:LPACCESSIBLE;var pvarChild:variant):HRESULT;stdcall;
function CreateStdAccessibleObject(wnd:HWND;idObject:longint;riid:TGUID;ppvObject:LPACCESSIBLE):HRESULT;stdcall;
function CreateStdAccessibleProxyA(wnd:HWND;pszClassName:pchar;idObject:longint;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;
function CreateStdAccessibleProxyW(wnd:HWND;pszClassName:pchar;idObject:longint;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;
function CreateStdAccessibleProxy(wnd:HWND;pszClassName:pchar;idObject:longint;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;
function AccessibleChildren (paccContainer:IAccessible;iChildStart,cChildren:longint;rgvarChildren:pvariant;var pcObtained:longint):HRESULT;stdcall;
function GetRoleTextA(lRole:DWORD;lpszRole:pchar;cchRoleMax:byte):HRESULT;stdcall;
function GetRoleTextW(lRole:DWORD;lpszRole:pchar;cchRoleMax:byte):HRESULT;stdcall;
function GetRoleText (lRole:DWORD;lpszRole:pchar;cchRoleMax:byte):HRESULT;stdcall;
function GetStateTextA(lStateBit:DWORD;lpszState:pwidechar;cchState:byte):HRESULT;stdcall;
function GetStateTextW(lStateBit:DWORD;lpszState:pwidechar;cchState:byte):HRESULT;stdcall;
function GetStateText (lStateBit:DWORD;lpszState:pwidechar;cchState:byte):HRESULT;stdcall;


implementation


function GetOleaccVersionInfo(pdwVer,pdwBuild:pdword):HRESULT;stdcall; external ACCDLL;
function LresultFromObject(riid:TGUID;wParam:WPARAM;pAcc:LPACCESSIBLE):HRESULT;external ACCDLL;
function ObjectFromLresult(lResult:LRESULT;riid:TGUID;wParam:WPARAM;ppvObject:LPACCESSIBLE):HRESULT;external ACCDLL;
function WindowFromAccessibleObject(pAcc:IACCESSIBLE;var phwnd:HWND):HRESULT;external ACCDLL;
function AccessibleObjectFromWindow(hWnd:HWnd;dwId:DWord;const riid:TGUID;var ppvObject:pointer):HRESULT;external ACCDLL name'AccessibleObjectFromWindow';
function AccessibleObjectFromEvent(wnd:HWND;dwId:DWORD;dwChildId:DWORD;pAcc:LPACCESSIBLE;var pvarChild:variant):HRESULT;external ACCDLL;
function AccessibleObjectFromPoint(ptScreen:TPOINT;pAcc:LPACCESSIBLE;var pvarChild:variant):HRESULT;external ACCDLL;
function CreateStdAccessibleObject(wnd:HWND;idObject:longint;riid:TGUID;ppvObject:LPACCESSIBLE):HRESULT;external ACCDLL;
function CreateStdAccessibleProxyA(wnd:HWND;pszClassName:pchar;idObject:longint;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;external ACCDLL;
function CreateStdAccessibleProxyW(wnd:HWND;pszClassName:pchar;idObject:longint;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;external ACCDLL;
function CreateStdAccessibleProxy(wnd:HWND;pszClassName:pchar;idObject:longint;riid:TGUID;ppvObject:pointer):HRESULT;stdcall;external ACCDLL name 'CreateStdAccessibleProxyA';
function AccessibleChildren (paccContainer:IACCESSIBLE;iChildStart,cChildren:longint;rgvarChildren:Pvariant;var pcObtained:longint):HRESULT;external ACCDLL;
function GetRoleTextA(lRole:DWORD;lpszRole:pchar;cchRoleMax:byte):HRESULT; external ACCDLL;
function GetRoleTextW(lRole:DWORD;lpszRole:pchar;cchRoleMax:byte):HRESULT; external ACCDLL;
function GetRoleText(lRole:DWORD;lpszRole:pchar;cchRoleMax:byte):HRESULT; external ACCDLL name 'GetRoleTextA';
function GetStateTextA(lStateBit:DWORD;lpszState:pwidechar;cchState:byte):HRESULT; external ACCDLL;
function GetStateTextW(lStateBit:DWORD;lpszState:pwidechar;cchState:byte):HRESULT; external ACCDLL;
function GetStateText(lStateBit:DWORD;lpszState:pwidechar;cchState:byte):HRESULT; external ACCDLL name 'GetStateTextA';




begin
end.

(*

function GetOleaccVersionInfo         OK
function LresultFromObject
function ObjectFromLresult
function WindowFromAccessibleObject   OK
function AccessibleObjectFromWindow   OK
function AccessibleObjectFromEvent
function AccessibleObjectFromPoint
function CreateStdAccessibleObject
function CreateStdAccessibleProxyA
function CreateStdAccessibleProxyW
function CreateStdAccessibleProxy
function AccessibleChildren
function GetRoleTextA                 OK
function GetRoleTextW                 OK
function GetRoleText                  OK
function GetStateTextA                OK
function GetStateTextW                OK
function GetStateText                 OK



IACCESSIBLE
    function get_accParent            OK
    function get_accChildCount        OK
    function get_accChild             OK
    function get_accName              OK
    function get_accValue             OK
    function get_accDescription       OK
    function get_accRole              OK
    function get_accState             OK
    function get_accHelp              OK
    function get_accHelpTopic         OK
    function get_accKeyboardShortcut  OK
    function get_accFocus             OK
    function get_accSelection         OK
    function get_accDefaultAction     OK
    function accSelect
    function accLocation              OK
    function accNavigate              OK
    function accHitTest
    function accDoDefaultAction       OK
    function put_accName
    function put_accValue

*)

