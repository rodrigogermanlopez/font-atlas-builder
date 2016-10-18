/**
 *
 * Created by Rodrigo Lopez [blnk™] on 10/15/16.
 *
 */
package blnk.atlas {

import flash.display.BitmapData;
import flash.display.PNGEncoderOptions;
import flash.display.Stage;
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.AntiAliasType;
import flash.text.Font;
import flash.text.GridFitType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextLineMetrics;
import flash.utils.ByteArray;

public class FontAtlasBuilder {

	public static const LATIN_LOWERCASE:String = "abcdefghijklmnopqrstuvwxyz";
	public static const LATIN_UPPERCASE:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	public static const CYRILIC_LOWERCASE:String = "абвгдеёжзийклмнопрстуфхцчшщьыъэюя";
	public static const CYRILIC_UPPERCASE:String = "АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ";
	public static const DIGITS:String = "0123456789";
	public static const SYMBOLS1:String = "!;%:?*()_+-=.,/\\|\"'@#$^&{}[]";
	public static const CHARSET_LATIN1:String = LATIN_LOWERCASE + LATIN_UPPERCASE + DIGITS + SYMBOLS1;

	public static const KERNING_PAIRS:Vector.<String> = Vector.<String>([" A","A'","AC","AG","AO","AQ","AT","AU","AV","AW","AY","BA","BE","BL","BP","BR","BU","BV","BW","BY","CA","CO","CR","DA","DD","DE","DI","DL","DM","DN","DO","DP","DR","DU","DV","DW","DY","EC","EO","FA","FC","FG","FO","F.","F,","GE","GO","GR","GU","HO","IC","IG","IO","JA","JO","KO","L'","LC","LT","LV","LW","LY","LG","LO","LU","M","MG","MO","NC","NG","NO","OA","OB","OD","OE","OF","OH","OI","OK","OL","OM","ON","OP","OR","OT","OU","OV","OW","OX","OY","PA","PE","PL","PO","PP","PU","PY","P.","P,","P;","P:","QU","RC","RG","RY","RT","RU","RV","RW","RY","SI","SM","ST","SU","TA","TC","TO","UA","UC","UG","UO","US","VA","VC","VG","VO","VS","WA","WC","WG","WO","YA","YC","YO","YS","ZO","Ac","Ad","Ae","Ag","Ao","Ap","Aq","At","Au","Av","Aw","Ay","Bb","Bi","Bk","Bl","Br","Bu","By","B.","B,","Ca","Cr","C.","C,","Da","D.","D,","Eu","Ev","Fa","Fe","Fi","Fo","Fr","Ft","Fu","Fy","F.","F,","F;","F:","Gu","He","Ho","Hu","Hy","Ic","Id","Iq","Io","It","Ja","Je","Jo","Ju","J.","J,","Ke","Ko","Ku","Lu","Ly","Ma","Mc","Md","Me","Mo","Nu","Na","Ne","Ni","No","Nu","N.","N,","Oa","Ob","Oh","Ok","Ol","O.","O,","Pa","Pe","Po","Rd","Re","Ro","Rt","Ru","Si","Sp","Su","S.","S,","Ta","Tc","Te","Ti","To","Tr","Ts","Tu","Tw","Ty","T.","T,","T;","T:","Ua","Ug","Um","Un","Up","Us","U.","U,","Va","Ve","Vi","Vo","Vr","Vu","V.","V,","V;","V:","Wd","Wi","Wm","Wr","Wt","Wu","Wy","W.","W,","W;","W:","Xa","Xe","Xo","Xu","Xy","Yd","Ye","Yi","Yp","Yu","Yv","Y.","Y,","Y;","Y:","ac","ad","ae","ag","ap","af","at","au","av","aw","ay","ap","bl","br","bu","by","b.","b,","ca","ch","ck","da","dc","de","dg","do","dt","du","dv","dw","dy","d.","d,","ea","ei","el","em","en","ep","er","et","eu","ev","ew","ey","e.","e,","fa","fe","ff","fi","fl","fo","f.","f,","ga","ge","gh","gl","go","gg","g.","g,","hc","hd","he","hg","ho","hp","ht","hu","hv","hw","hy","ic","id","ie","ig","io","ip","it","iu","iv","ja","je","jo","ju","j.","j,","ka","kc","kd","ke","kg","ko","la","lc","ld","le","lf","lg","lo","lp","lq","lu","lv","lw","ly","ma","mc","md","me","mg","mn","mo","mp","mt","mu","mv","my","nc","nd","ne","ng","no","np","nt","nu","nv","nw","ny","ob","of","oh","oj","ok","ol","om","on","op","or","ou","ov","ow","ox","oy","o.","o,","pa","ph","pi","pl","pp","pu","p.","p,","qu","t.","ra","rd","re","rg","rk","rl","rm","rn","ro","rq","rr","rt","rv","ry","r.","r,","sh","st","su","s.","s,","td","ta","te","to","t.","t,","ua","uc","ud","ue","ug","uo","up","uq","ut","uv","uw","uy","va","vb","vc","vd","ve","vg","vo","vv","vy","v.","v,","wa","wx","wd","we","wg","wh","wo","w.","w,","xa","xe","xo","y.","y,","ya","yc","yd","ye","yo","Wa", " a","a "," b","b "," c","c "," d","d "," e","e "," f","f "," g","g "," h","h "," i","i "," j","j "," k","k "," l","l "," m","m "," n","n "," o","o "," p","p "," q","q "," r","r "," s","s "," t","t "," u","u "," v","v "," w","w "," x","x "," y","y "," z","z "," A","A "," B","B "," C","C "," D","D "," E","E "," F","F "," G","G "," H","H "," I","I "," J","J "," K","K "," L","L "," M","M "," N","N "," O","O "," P","P "," Q","Q "," R","R "," S","S "," T","T "," U","U "," V","V "," W","W "," X","X "," Y","Y "," Z","Z "]) ;

	private const MATRIX:Matrix = new Matrix();
	private const POINT:Point = new Point();
	private const RECT:Rectangle = new Rectangle();

	private var _tmp_char_bd:BitmapData;
	private var _tmp_char_bd_rect:Rectangle;
	private var _tmp_tf:TextField;
	private var _kerning1_tf:TextField;
	private var _kerning2_tf:TextField;

	private var tmpCharSize:Point = new Point();
	private var _biggestCharSize:int;
//	private var _kerningPairs_arr:Array;

	public var chars:String = CHARSET_LATIN1;
	public var kerningPairs:Vector.<String> = KERNING_PAIRS ;

	public var padding:int = 2;

//	public var useRetinaDisplay:Boolean = false;
	private var _bufferFonts:Array;
	private var _currentFormat:TextFormat;

	// current font model.
	private var _fontVO:Object = {};

	private var _fontsVO:Array;
	private var _fontMapById:Object = {};


	private var _embedFonts:Array;

	public var onGlyphProcessed:Function;
	public var onPackComplete:Function;

	// we can define a directory to export all xmls and png.
	public var exportDir:File;

	public var atlasBgColor:uint = 0x0;
	public var atlasWidth:int = 512;
	public var atlasHeight:int = 512;

	private var _packer:MaxRectsBinPack;
	private var _glyphList:Array;
	public var atlas_bd:BitmapData;
	public var cropIfExceeds:Boolean = false;
	public var roundXMLValues:Boolean = false;
	public var calculateKerning:Boolean = true;

	// filename used in xml pages and to export the PNG.
	// Dont' forget to INCLUDE the .png extension.
	public var fontAtlasFilename:String = "fonts.png";

	// compress even more the atlas by using 90deg rotated rects.
	// requires change in Starlings BitmapFont to work with rotated glyphs, although
	// maybe batching breaks when rendering a lot of text.
	public var allowRotation:Boolean = false ;

	// stage is required for System Fonts to calculate the glyph bounds.
	// otherwise xAdvance will store a tiny/ridiculous value.
	private var _stage:Stage;


	// defines the initial value to pack an unknown canvas size.
	public var autoSizeStartValue:int = 32;

	// defines the increment in width/height for the canvas when packing the rectangles.
	// on each iteration it'll sum up this value until all glyphs fits on the canvas area.
	// example: 128, 160, 192, 224, ...
	public var autoSizeInc:int = 32;

	// this flag forces the atlas size to be power of 2.
	// it overrides autoSizeInc. But works with autoSize (canvasW==-1 || canvasH==-1)
	// and smartAxisAutoSize.
	public var forceSquareAtlasSize:Boolean;

	// this flag defines that each loop on autoSize (ONLY when atlasWidth=atlasHeight<=0 )
	// will increase only 1 axis at a time, maybe making the packing more compressed than a
	// square image.
	public var smartAxisAutoSize:Boolean;


	/**
	 * Constructor
	 * @param nativeStage
	 */
	public function FontAtlasBuilder( nativeStage:Stage = null ) {
		_stage = nativeStage;
		if ( !_stage ) {
			trace( "ERROR: Fonts requires to pass the Stage to the constructor. Glyph metrics will not be calculated correctly otherwise" );
		}
		_tmp_tf = new TextField();
		_tmp_tf.autoSize = "left";
		_tmp_tf.text = " j@ ";
		_tmp_tf.antiAliasType = AntiAliasType.ADVANCED;
		_tmp_tf.gridFitType = GridFitType.SUBPIXEL;
		_fontsVO = [];
	}

	public function defineAtlas( width:uint, height:uint, bgColor:uint = 0x0 ):void {
		atlasWidth = width;
		atlasHeight = height;
		atlasBgColor = bgColor;
	}

	/**
	 * Utility method to avoid passing a TextFormat, and pass the needed params only.
	 * Useful to avoid conflicts with Starling's TextFormat.
	 * @param fontId
	 * @param fontName
	 * @param fontSize
	 * @param fontColor
	 * @param bold
	 * @param italic
	 */
	public function addFontByStyle( fontId:String, fontName:String, fontSize:uint, fontColor:uint = 0x0,
									bold:Boolean = false, italic:Boolean = false ):void {
		addFontByTextFormat( fontId, new TextFormat( fontName, fontSize, fontColor, bold, italic ) );
	}

	public function addFontByTextFormat( fontId:String, format:TextFormat ):void {
		// create text map
		var fontVO:Object = {format: format, id: fontId};
		fontVO.charString = chars ;
		_fontsVO.push( fontVO );
		_fontMapById[fontId] = fontVO;
		_tmp_tf.setTextFormat( format );
		if ( tmpCharSize.x < _tmp_tf.width ) {
			tmpCharSize.x = _tmp_tf.width;
		}
		if ( tmpCharSize.y < _tmp_tf.height ) {
			tmpCharSize.y = _tmp_tf.height;
		}
		if ( format.size > _biggestCharSize ) {
			_biggestCharSize = uint( format.size );
		}
	}

	public function process():void {
		_embedFonts = Font.enumerateFonts( false );
		// create the tmp bdata to store the biggest char.
		var tw:int = tmpCharSize.x;
		var th:int = tmpCharSize.y;

		// fix the atlas filename
		if ( fontAtlasFilename.indexOf( ".png" ) == -1 )
			fontAtlasFilename += ".png";

		_tmp_char_bd = new BitmapData( tw, th );
		_tmp_char_bd_rect = _tmp_char_bd.rect;
		_bufferFonts = _fontsVO.concat();
		createNextFont();
	}

	private function createNextFont():void {
		if ( _bufferFonts.length == 0 ) {
			/// process complete.
			trace( "Glyph generation completed." );
			if ( onGlyphProcessed ) onGlyphProcessed();
			return;
		}
		_fontVO = _bufferFonts.pop();
		_currentFormat = _fontVO.format;
		var isEmbed:Boolean = isFontEmbedded( _currentFormat.font );
		if ( !isEmbed ) {
			trace( "WARNING: Font '" + _currentFormat.font + "' is a System Font, tracking and antialias will not be accurate and kerning will not be available." );
		}
		_stage.addChild( _tmp_tf );
		_tmp_tf.embedFonts = isEmbed;

		var originalSize:uint = uint( _currentFormat.size );

		// If we need to draw the textfield at 2x.
//		if ( useRetinaDisplay ) {
//			_currentFormat.size = originalSize * 2;
//		}
		_tmp_tf.setTextFormat( _currentFormat );
		_tmp_tf.defaultTextFormat = _currentFormat;

		var fontVO:Object = _fontVO;
		_tmp_tf.text = "Jjlg" ;
		var metrics:TextLineMetrics = _tmp_tf.getLineMetrics( 0 );
		var lineHeight:Number = Math.max(metrics.height, _tmp_tf.textHeight);

		fontVO.fontXml = new XML( <font></font> );
		var infoNode:XML = new XML( <info /> );
		infoNode.@face = _currentFormat.font;
		infoNode.@size = int( originalSize );
		infoNode.@unicode = 1;
		infoNode.@stretchH = 100;
		infoNode.@aa = 1;
		infoNode.@spacing = "0,0";
		infoNode.@outline = 0;
		infoNode.@smooth = 1;
		infoNode.@padding = [padding, padding, padding, padding].join( ',' );

		var currentFont:Font;

		if ( !isEmbed ) {
			// As Font is not embedded, fontStyle will not reflect the actual style. Read the TextFormat instead.
			infoNode.@bold = _currentFormat.bold ? 1 : 0;
			infoNode.@italic = _currentFormat.italic ? 1 : 0;
		} else {
			currentFont = getFontByName( _currentFormat.font );
			infoNode.@bold = currentFont.fontStyle.toLowerCase().indexOf( "bold" ) > -1 ? 1 : 0;
			infoNode.@italic = currentFont.fontStyle.toLowerCase().indexOf( "italic" ) > -1 ? 1 : 0;
		}

		var commonNode:XML = new XML( <common /> );
		commonNode.@lineHeight = roundXMLValues ? int( lineHeight ) : lineHeight;
		commonNode.@base = metrics.ascent + 2;
		commonNode.@packed = 0;

		fontVO.fontXml.appendChild( infoNode );
		fontVO.fontXml.appendChild( commonNode );

		// Starling fails to point to a file path with
		// different name than the xml, so it can't map the font
		// and disposes the XML, so we can't use AssetManager.

		/*fontVO.fontXml.appendChild( new XML( <pages>
			<page id="0" file={fontAtlasFilename}/>
		</pages> ) );*/

		// so, if the fontId is "verdana", the xml and png should be "verdana"
		fontVO.fontXml.appendChild( new XML( <pages>
			<page id="0" file={fontVO.id+".png"}/>
		</pages> ) );

		// store all charVO information.
		var charsInfo:Array = fontVO.charsInfo = [];

		var fontCharsString:String = fontVO.charString ;

		// first char is always space
		if ( fontCharsString.charAt( 0 ) != " " ) {
			fontCharsString = " " + fontCharsString ;
		}

		// MAKE SURE THE FIRST CHAR IS THE SACE.
		// first the space char.
		for ( var i:int = 0; i < fontCharsString.length; i++ ) {
			var charStr:String = fontCharsString.charAt( i );
			var charCode:int = charStr.charCodeAt( 0 );
			var charVO:Object = {char: charStr, code: charCode};
			charVO.fontVO = fontVO;
			if ( charStr == " " ) {
				_tmp_tf.text = charStr;
				charVO.charBounds = _tmp_tf.getCharBoundaries( 0 );
				charVO.charW = charVO.charBounds.width;
			} else {
				_tmp_tf.text = " " + charStr + " ";
				charVO.charBounds = _tmp_tf.getCharBoundaries( 1 );
				if ( !charVO.charBounds ) {
					// ERROR, no char found.
					trace( "Char " + charStr + " [" + charCode + "] invalid." );
					delete charVO.fontVO;
					continue;
				}
				_tmp_char_bd.fillRect( _tmp_char_bd_rect, 0x0 );
				_tmp_char_bd.draw( _tmp_tf, MATRIX, null, null, null, true );
				_tmp_tf.text = charStr;

				// get only the char bounds.
				var colorBounds:Rectangle = _tmp_char_bd.getColorBoundsRect( 0xFFFFFFFF, 0x000000, false );
				if ( colorBounds.isEmpty() ) {
					trace( "Error char '" + charStr + '" is invalid.' );
					continue;
				}
				charVO.area = new Rectangle();
				charVO.area.y = colorBounds.y;
				charVO.area.x = -( colorBounds.x - charVO.charBounds.x );
				charVO.area.width = charVO.charBounds.width;
				charVO.area.height = charVO.charBounds.height;

				colorBounds.width += padding;
				colorBounds.height += padding;

				var char_bd:BitmapData = new BitmapData( colorBounds.width, colorBounds.height );
				char_bd.copyPixels( _tmp_char_bd, colorBounds, POINT );
				charVO.bd = char_bd;
				charVO.charW = charVO.area.width;
			}
			charsInfo[charsInfo.length] = charVO;
		}
		var charsNode:XML = new XML( <chars></chars> );
		charsNode.@count = charsInfo.length;
		fontVO.fontXml.appendChild( charsNode );

		// evaluate kerning.
		if ( isEmbed && calculateKerning ) {
			if ( !_kerning1_tf ) {
				_kerning1_tf = new TextField();
				_kerning2_tf = new TextField();
				_kerning1_tf.embedFonts = true;
				_kerning2_tf.embedFonts = true;
				_kerning1_tf.autoSize = _kerning2_tf.autoSize = "left";
				_kerning1_tf.antiAliasType = _kerning2_tf.antiAliasType = AntiAliasType.NORMAL;
			}
			var kerningsXML:XML = new XML( <kernings></kernings> );
			_currentFormat.kerning = false;
			_kerning1_tf.defaultTextFormat = _currentFormat;

			_currentFormat.kerning = true;
			_kerning2_tf.defaultTextFormat = _currentFormat;

			_stage.addChild( _kerning1_tf );
			_stage.addChild( _kerning2_tf );

			for ( i = 0; i < kerningPairs.length; i++ ) {
				var pair:String = kerningPairs[i];
				if ( !currentFont.hasGlyphs( pair ) || pair.length != 2 ) {
					trace( "Kerning pair nor available: " + pair );
					continue;
				}
				_kerning2_tf.text = _kerning1_tf.text = pair;
				var bounds1:Rectangle = _kerning1_tf.getCharBoundaries( 1 );
				var bounds2:Rectangle = _kerning2_tf.getCharBoundaries( 1 );
				if ( bounds1.width != bounds2.width ) {
					var kerningNode:XML = new XML( <kerning /> );
					kerningNode.@first = pair.charCodeAt( 0 );
					kerningNode.@second = pair.charCodeAt( 1 );
					var amount:Number = -(bounds1.width - bounds2.width );
//					trace(pair, ">",amount,bounds1.width, bounds2.width);
					kerningNode.@amount = roundXMLValues ? int( amount ) : decimal( amount );
					kerningsXML.appendChild( kerningNode );
				}
			}
			var childCount:int = kerningsXML.children().length();
			if ( childCount > 0 ) {
				kerningsXML.@count = childCount;
				fontVO.fontXml.appendChild( kerningsXML );
			}
			_stage.removeChild( _kerning1_tf );
			_stage.removeChild( _kerning2_tf );
		}
		if ( _tmp_tf.parent ) _tmp_tf.parent.removeChild( _tmp_tf );
		createNextFont();
	}


	public function pack():void {

		// merge all the fonts.
		_glyphList = [];
		for each( var fontVO:Object in _fontsVO ) {
			_glyphList = _glyphList.concat( fontVO.charsInfo );
		}
		// store the current "items".
		var list:Vector.<Rectangle> = new Vector.<Rectangle>();
		for ( var i:int = 0; i < _glyphList.length; i++ ) {
			var charVO:Object = _glyphList[i];
			if ( charVO.bd ) {
				charVO.atlasRect = new Rectangle( 0, 0, charVO.bd.width, charVO.bd.height );
			} else {
				charVO.atlasRect = new Rectangle( 0, 0, 1, 1 );
			}
			list.push( charVO.atlasRect );
		}


		// -- Smart packing -- //

		var fixedCanvasW:Boolean = atlasWidth > padding;
		var fixedCanvasH:Boolean = atlasHeight > padding;

		// Smart expansion flag when "autoSize"==true && smartAxisAutoSize==true
		var expandW:Boolean = true ;

		if ( forceSquareAtlasSize ) {
			atlasWidth = getNextPowerOfTwo(atlasWidth);
			atlasHeight = getNextPowerOfTwo(atlasHeight);
			autoSizeStartValue = getNextPowerOfTwo(autoSizeStartValue);
		}

		var canvasW:int = fixedCanvasW ? atlasWidth : autoSizeStartValue;
		var canvasH:int = fixedCanvasH ? atlasHeight : autoSizeStartValue;

		tryNextAtlasSize();

		function tryNextAtlasSize():void {
			expandW = !expandW ;
			if ( !_packer ) {
				_packer = new MaxRectsBinPack( canvasW - padding, canvasH - padding );
			} else {
				_packer.init( canvasW - padding, canvasH - padding );
			}
			_packer.allowFlip = allowRotation;
			_packer.onComplete = packingComplete;
			_packer.insertBulk( list.concat(), MaxRectsBinPack.METHOD_RECT_BEST_AREA_FIT );
		}

		function packingComplete():void {
			var diff:int = _glyphList.length - _packer.indices.length;
			trace( "Packing items diff = " + diff );
			if ( diff > 0 ) {
				// error!
				if ( fixedCanvasW && fixedCanvasH ) {
					trace( diff + " items were skipped from the packing! Use a dynamic size atlas" );
					onPackCompleted();
				} else {
					var processAxisWidth:Boolean = !smartAxisAutoSize ? true : expandW ;
					var processAxisHeight:Boolean = !smartAxisAutoSize ? true : !expandW ;
					if ( !fixedCanvasW && processAxisWidth )
						canvasW = forceSquareAtlasSize ? getNextPowerOfTwo(++canvasW) : canvasW + autoSizeInc ;
					if ( !fixedCanvasH && processAxisHeight )
						canvasH = forceSquareAtlasSize ? getNextPowerOfTwo(++canvasH) : canvasH + autoSizeInc;
					trace( "Trying next atlas size=" + canvasW + "x" + canvasH );
					tryNextAtlasSize();
				}
			} else {
				atlasWidth = canvasW;
				atlasHeight = canvasH;
				trace( "Final atlas size=" + canvasW + "x" + canvasH );
				onPackCompleted();
			}
		}
	}

	private function onPackCompleted():void {
		atlas_bd = new BitmapData( atlasWidth, atlasHeight, true, atlasBgColor );

		var charNode:XML;
		var maxW:int = 0;
		var maxH:int = 0;

		var diff:int = _glyphList.length - _packer.indices.length;
		if ( diff > 0 ) {
			trace( "WARNING: Bigger spritesheet required, " + diff + " chars were skipped." );
		}

		for ( var i:int = 0; i < _packer.indices.length; i++ ) {
			var idx:int = _packer.indices[i];
			var r:Rectangle = _packer.usedRectangles[i];
			if ( cropIfExceeds ) {
				if ( maxW < r.right ) maxW = r.right;
				if ( maxH < r.bottom ) maxH = r.bottom;
			}
			var charVO:Object = _glyphList[idx];
			if ( charVO.bd ) {
				POINT.setTo( r.x + padding, r.y + padding );
				charVO.canvasRect = r;
				charVO.isFlipped = _packer.allowFlip && charVO.bd.width != r.width;
				if ( charVO.isFlipped ) {
					MATRIX.identity();
					MATRIX.rotate( Math.PI / 2 );
					MATRIX.translate( r.x + r.width, r.y );
					atlas_bd.draw( charVO.bd, MATRIX );
				} else {
					atlas_bd.copyPixels( charVO.bd, charVO.bd.rect, POINT, null, null, true );
				}
				charVO.bd.dispose();
			}
			// create atlas xml
			charNode = new XML( <char page="0" xoffset="0" yoffset="0"/> );
			charNode.@id = charVO.code;
			if ( charVO.area ) {
				charNode.@xoffset = roundXMLValues ? int( -charVO.area.x ) : decimal( -charVO.area.x );
				charNode.@yoffset = roundXMLValues ? int( charVO.area.y ) : decimal( charVO.area.y );
			}
			if ( charVO.isFlipped ) {
				charNode.@rotated = true;
				r.y -= padding ;
				r.height += padding ;
			}
			charNode.@x = r.x + padding;
			charNode.@y = r.y + padding;
			charNode.@width = r.width - padding;
			charNode.@height = r.height - padding;
			charNode.@xadvance = roundXMLValues ? int( charVO.charW ) : charVO.charW;
			charNode.@page = 0;
			charNode.@chnl = 15;

			XML( charVO.fontVO.fontXml ).chars[0].appendChild( charNode );
		}

		if ( cropIfExceeds ) {
			maxW += padding;
			maxH += padding;
			var tmp_bd:BitmapData = new BitmapData( maxW, maxH, true, atlasBgColor );
			RECT.setTo( 0, 0, maxW, maxH );
			POINT.setTo( 0, 0 );
			tmp_bd.copyPixels( atlas_bd, RECT, POINT, null, null, true );
			atlas_bd = tmp_bd;
		}

		for each( var fontVO:Object in _fontsVO ) {
			var fontXml:XML = XML( fontVO.fontXml );
			fontXml.common[0].@scaleW = atlas_bd.width;
			fontXml.common[0].@scaleH = atlas_bd.height;
		}

		if ( onPackComplete )  onPackComplete();
	}

	public function getFontStyleXML( fontId:String ):XML {
		var fontVO:Object = _fontMapById[fontId];
		if( !fontVO ){
			trace("ERROR: font style '" + fontId + "' not available.");
			return null ;
		}
		return fontVO.fontXml as XML;
	}

	public function getFontStylesNames():Array {
		var output:Array = [] ;
		for ( var key:String in _fontMapById ) output.push(key) ;
		output.sort(Array.CASEINSENSITIVE) ;
		return output ;
	}

	private function getFontByName( name:String, onlyEmbed:Boolean = true ):Font {
		var fontList:Array = onlyEmbed ? _embedFonts : Font.enumerateFonts( true );
		for each( var f:Font in fontList ) {
			if ( f.fontName == name ) return f;
		}
		return null;
	}

	private function isFontEmbedded( fontName:String ):Boolean {
		for each( var font:Font in _embedFonts ) {
			if ( font.fontName == fontName ) return true;
		}
		return false;
	}

	[Inline]
	private static function decimal( val:Number ):Number {
		return int( ( val ) * 1000 ) / 1000;
	}

	public function exportAll():void {
		for ( var key:String in _fontMapById ) {
			exportXml( key );
		}
		exportBitmap();
	}

	public function exportXml( fontId:String ):void {
		if ( !_fontMapById[fontId] ) {
			trace( "ERROR: Font id '" + fontId + "' not defined" );
			return;
		} else if ( exportDir == null ) {
			trace( "ERROR: set ::exportDir before calling this method." );
			return;
		} else if ( exportDir.exists && !exportDir.isDirectory ) {
			trace( "ERROR: '" + exportDir.name + "' is not a directory." );
			return;
		}
		var file:File = exportDir.resolvePath( fontId + ".xml" );
		var fontXml:XML = _fontMapById[fontId].fontXml;
		var fs:FileStream = new FileStream();
		fs.open( file, FileMode.WRITE );
		fs.writeUTFBytes( fontXml.toString() );
		fs.close();
	}

	public function exportBitmap():void {
		if ( exportDir == null ) {
			trace( "ERROR: set ::exportDir before calling this method." );
			return;
		} else if ( exportDir.exists && !exportDir.isDirectory ) {
			trace( "ERROR: '" + exportDir.name + "' is not a directory." );
			return;
		}
		var file:File = exportDir.resolvePath( fontAtlasFilename );
		var ba:ByteArray = atlas_bd.encode( atlas_bd.rect, new PNGEncoderOptions( true ) );
		ba.position = 0;
		var fs:FileStream = new FileStream();
		fs.open( file, FileMode.WRITE );
		fs.writeBytes( ba );
		fs.close();
	}

	public function addKernings( list:Array ):void {
		for each( var kn:String in list ){
			if( kn.length==2 && kerningPairs.indexOf(kn)==-1 )
				kerningPairs[kerningPairs.length] = kn ;
		}
	}


	//===================================================================================================================================================
	//
	//      ------  UTILITIES
	//
	//===================================================================================================================================================
	/**
	 * Taken from Starling's MathUtils.
	 * @param number
	 * @return
	 */
	public static function getNextPowerOfTwo( number:Number ):int {
		if ( number is int && number > 0 && (number & (number - 1)) == 0 ) // see: http://goo.gl/D9kPj
			return number;
		else {
			var result:int = 1;
			number -= 0.000000001; // avoid floating point rounding errors
			while ( result < number ) result <<= 1;
			return result;
		}
	}

}
}