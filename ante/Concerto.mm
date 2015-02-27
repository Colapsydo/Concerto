<map version="0.9.0">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1424860864879" ID="ID_492681033" MODIFIED="1424947853463" TEXT="Concerto">
<node CREATED="1424862033188" ID="ID_781829740" MODIFIED="1424862035103" POSITION="right" TEXT="Model">
<node CREATED="1424860876668" ID="ID_881804673" MODIFIED="1424862764495" TEXT="Distirbution">
<node CREATED="1424860889612" ID="ID_194341148" MODIFIED="1424860903118" TEXT="Determine deux paires"/>
<node CREATED="1424860903459" ID="ID_1960412616" MODIFIED="1424860918133" TEXT="la premi&#xe8;re paire devient la paire active"/>
<node CREATED="1424860918515" ID="ID_935033382" MODIFIED="1424860948689" TEXT="La 2nde parie devient la 1&#xe8;re"/>
<node CREATED="1424860949140" ID="ID_342621816" MODIFIED="1424860960002" TEXT="Determine la seconde paire"/>
</node>
<node CREATED="1424860974301" ID="ID_1464910680" MODIFIED="1424860989408" TEXT="Active pair">
<node CREATED="1424860993179" ID="ID_226054032" MODIFIED="1424861000473" TEXT="Active pair tombe"/>
<node CREATED="1424861001159" ID="ID_607910884" MODIFIED="1424861016030" TEXT="elle est soumise aux controles du joueur"/>
<node CREATED="1424861016480" ID="ID_805514084" MODIFIED="1424861027230" TEXT="elle est contrainte par les infos de la grille">
<node CREATED="1424861028366" ID="ID_1557402124" MODIFIED="1424861036783" TEXT="position d&apos;arriv&#xe9;e"/>
<node CREATED="1424861037052" ID="ID_166222662" MODIFIED="1424861043044" TEXT="Limite gauche droite"/>
</node>
<node CREATED="1424861052991" ID="ID_1919330239" MODIFIED="1424861093336" TEXT="Elle touche un objet (sol ou note) avec la master ou la slave">
<node CREATED="1424861103416" ID="ID_962289172" MODIFIED="1424861117117" TEXT="Activation du temps de controle au sol"/>
</node>
<node CREATED="1424861118600" ID="ID_1521766895" MODIFIED="1424861163284" TEXT="Insertion de la paire dans la grid quand le temps de controle au sol termin&#xe9;"/>
</node>
<node CREATED="1424861169595" ID="ID_1685181628" MODIFIED="1424861176794" TEXT="Grille">
<node CREATED="1424887352841" ID="ID_315023674" MODIFIED="1424887381253" TEXT="Durant la chute controle des solutions avec le possible point d&apos;atterissage"/>
<node CREATED="1424861178494" ID="ID_1792196456" MODIFIED="1424861197580" TEXT="Controle de gravit&#xe9;">
<node CREATED="1424861198511" ID="ID_1527404983" MODIFIED="1424861212601" TEXT="Est ce que la nouvelle paire arriv&#xe9;e &#xe0; besoin d&apos;un mouvement de gravit&#xe9; ?"/>
<node CREATED="1424861216419" ID="ID_80605995" MODIFIED="1424861354348" TEXT="Si oui le dertminer et l&apos;appliquer"/>
</node>
<node CREATED="1424861230500" ID="ID_11760644" MODIFIED="1424861275613" TEXT="Controle des Solutions, il aura d&#xe9;j&#xe0; &#xe9;t&#xe9; calcul&#xe9; pendant la chute bas&#xe9; sur les futurs positions, c&apos;est donc le dernier en date qui compte"/>
<node CREATED="1424861276432" ID="ID_14900653" MODIFIED="1424861402578" TEXT="1 / Destruction/Conversion si besoin est ?"/>
<node CREATED="1424861293173" ID="ID_1134677427" MODIFIED="1424861418199" TEXT="2 / Controle de la gravit&#xe9;">
<node CREATED="1424861302993" ID="ID_748770839" MODIFIED="1424861317114" TEXT="Est qu&apos;apr&#xe8;s destruction il y a besoin de bouger des paires"/>
<node CREATED="1424861332660" ID="ID_1229654731" MODIFIED="1424861347416" TEXT="Si oui le determiner et le faire"/>
</node>
<node CREATED="1424861420354" ID="ID_1698543125" MODIFIED="1424861429156" TEXT="Boucle 1 / 2 autant de fois que necessaire"/>
<node CREATED="1424887055617" ID="ID_506187244" MODIFIED="1424887065809" TEXT="une fois fini d&#xe9;finir les premi&#xe8;re cellule vide"/>
<node CREATED="1424861435691" ID="ID_255175434" MODIFIED="1424861443305" TEXT="Retour &#xe0; la distribution"/>
</node>
</node>
<node CREATED="1424862024335" HGAP="23" ID="ID_1834682010" MODIFIED="1424947917613" POSITION="left" TEXT="View" VSHIFT="-91">
<node CREATED="1424862067736" ID="ID_209966278" MODIFIED="1424862083004" TEXT="Distribution">
<node CREATED="1424862100005" ID="ID_1924238707" MODIFIED="1424862111200" TEXT="Paire de noteball simple"/>
</node>
<node CREATED="1424862083375" ID="ID_1055736736" MODIFIED="1424862093940" TEXT="Active pair">
<node CREATED="1424862117281" ID="ID_1145697163" MODIFIED="1424862140037" TEXT="Paire de note ball simple"/>
<node CREATED="1424862140607" ID="ID_244241444" MODIFIED="1424862164143" TEXT="Container avec Master et Slave s&#xe9;par&#xe9; pour les rotations"/>
</node>
<node CREATED="1424862085562" ID="ID_275769749" MODIFIED="1424862089938" TEXT="Grille">
<node CREATED="1424862190730" ID="ID_1765860465" MODIFIED="1424862204474" TEXT="Ensemble de note ball simple"/>
<node CREATED="1424862206386" ID="ID_641803961" MODIFIED="1424862222520" TEXT="Essaie sur la fusion de noteball de meme type">
<node CREATED="1424862224238" ID="ID_1615746152" MODIFIED="1424862232250" TEXT="Fusion &#xe0; l&apos;arret"/>
<node CREATED="1424862232810" ID="ID_1865964761" MODIFIED="1424862242070" TEXT="Retrait de la fusion lors de la gravit&#xe9;"/>
<node CREATED="1424862242344" ID="ID_17393230" MODIFIED="1424862254481" TEXT="Retrait de la fusion lors de l&apos;animation d&apos;impact de chute"/>
<node CREATED="1424862254925" ID="ID_1477228984" MODIFIED="1424862268502" TEXT="Retrait de la fusion lors d&apos;explosion"/>
</node>
</node>
</node>
<node CREATED="1424947865841" HGAP="49" ID="ID_604221537" MODIFIED="1424947920626" POSITION="left" TEXT="Controller" VSHIFT="9">
<node CREATED="1424947877229" ID="ID_930590141" MODIFIED="1424947880110" TEXT="Keyboard">
<node CREATED="1424947881917" ID="ID_1703387179" MODIFIED="1424947913254" TEXT="Recoit les keyboard event depuis PlaygroundView"/>
<node CREATED="1424947913717" ID="ID_436539893" MODIFIED="1424947934340" TEXT="KeyUp &amp;&amp; KeyDown"/>
<node CREATED="1424947934857" ID="ID_944788043" MODIFIED="1424947947359" TEXT="Boolean var pour chaque touche">
<node CREATED="1424948092034" ID="ID_830664359" MODIFIED="1424948112961" TEXT="Rotation Trig">
<node CREATED="1424948157074" ID="ID_1104970062" MODIFIED="1424948163488" TEXT="One action Press"/>
</node>
<node CREATED="1424948103703" ID="ID_1239542776" MODIFIED="1424948154512" TEXT="Rotaiton AntiTrig">
<node CREATED="1424948165598" ID="ID_836892367" MODIFIED="1424948169493" TEXT="One Action Press"/>
</node>
<node CREATED="1424948125254" ID="ID_886176584" MODIFIED="1424948131317" TEXT="Droite/Gauche">
<node CREATED="1424948172115" ID="ID_1880509839" MODIFIED="1424948220701" TEXT="first time action, wait, auto fire"/>
</node>
<node CREATED="1424948131857" ID="ID_761700498" MODIFIED="1424948133804" TEXT="Bas">
<node CREATED="1424948224568" ID="ID_610336585" MODIFIED="1424948227966" TEXT="Continue"/>
</node>
</node>
</node>
</node>
</node>
</map>
