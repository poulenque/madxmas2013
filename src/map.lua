function Map(name)

	function map_path(map, file)
		return "graphics/map/" .. map .. "/" .. file
	end

	local self = {}
	local zoom = 1
	local loop_x
	local loop_y

	-- Collision data user by canWalk
	local coldata = love.image.newImageData(map_path(name, "collision.png"))
	local coldata_height = coldata:getHeight()
	local coldata_width  = coldata:getWidth()

	-- Map objects
	local objects = {}

	-- Bottom layer
	local img = love.graphics.newImage(map_path(name, "map.png"))
	local img_quad = love.graphics.newQuad(
		0, 0, img:getWidth(), img:getHeight(), img:getWidth(), img:getHeight())
	local bottom_layer = Object(0, -10000, -1000) -- High z-value ==> on bottom
	function bottom_layer.draw()
		love.graphics.draw(img, img_quad, loop_x, 0, 0, zoom)
		love.graphics.draw(img, img_quad, 0, 0, 0, zoom)
		love.graphics.draw(img, img_quad, -loop_x, 0, 0, zoom)
	end
	table.insert(objects, bottom_layer)

	loop_x=2910
	loop_y=img:getHeight()

	function self.get_loop_x()
		return loop_x
	end
	function self.get_loop_y()
		return loop_y
	end


	--front layer
	local img_front = love.graphics.newImage(map_path(name, "front.png"))
	local img_front_quad = love.graphics.newQuad(
		0, 0, img_front:getWidth(), img_front:getHeight(), img_front:getWidth(), img_front:getHeight())
	local front_layer = Object(0, 10000, 1000) -- High z-value ==> on bottom
	function front_layer.draw()
		love.graphics.draw(img_front, img_front_quad, loop_x, 0, 0, zoom)
		love.graphics.draw(img_front, img_front_quad, 0, 0, 0, zoom)
		love.graphics.draw(img_front, img_front_quad, -loop_x, 0, 0, zoom)
	end
	table.insert(objects, front_layer)

-----------------------------------------


--                                                                                 D =D . DD                                                                                                               
--                                                                              .D$DDDDODDD .                  I  DD.                                                                                      
--                                                                           OD=$DO$$$$$D$DD .          ..  DDDDDDDDDDDDDDDDDD                                                                             
--                                                                            .DD8$$$$$$$$$DDD  DDDI?DDDDDDDD      .ZDDDD$$$$DDD                                                                           
--                                                                         ...DZ$$$$$$$$$$$DDDDDD.ODDD         . .DDDDZ$$$$$$$ZDD                                                                          
--                                                                         IDDDD$$$$$$$$$DDDD.                DNDDD$$$$$$$$$$$$$DD.                                                                        
--                                                                           .$O$$$$$$$DDD                 DDDD$$$$$$$$$$$$$$$ODDD       ..                                                                
--                                                                         .DDDN$$$$$$DDD              .DDDN$$$$$$$$$$$$$$$$DDDDDDDDDDDDDDDDND                                                  .DD..      
--                                                                            .N$DDDDDD               DDDD$$$$$$$$$$$$$$DDDDDDZ$$$$$$$$$$$$8$ZDDDDDDDD                                          DDDDDDD.   
--                                                                              DDDD.. D D         DDND$$$$$$$$$$$$$DDDDD$$$$$DDDDDDDDDDDDDD$$$$$$$DD                                          DDIIIIDDD.. 
--               ...                                                            . DN D DDDD      NDD$$$$$$$$$$$$$$DDDD$$$DD$$$$$$$$$$$$$$$$$DDDDDDN.  D                                       DDIIIIIIIDDD 
--             DDDDND    :NDDDD                                                   DD ZDD..    =DDD$$$$$$$$$$$$$DDDDDD$$$$$$DD$$$DDDDDDDDDDD$$$$$$DDNDDZ                                     :D8IIIIIIIIINDD
--            DD,,,DD    DD,,,D$                                                  .DDD      .DDD$$$$$$$$$$$$ZDDDO$$$DND$$$$$$8DD$$$$$$$$$$$ODDDOZ$$$NO                                    .DDDIIIIIIIIIND$ 
--            DD,,,,DD   D,,,,DD                                                 .DD     DDDDD$$$$$$$$$$$8DDDDND$$$$$$DDD$$$$$$$$$$ZDDDDDDDO$$$$8DDI                                      DDDIIIIIIIIIDD   
--             DD,,,ND   D,,,,~D.                                                .DD     DD$$$$$$$$$$$$$DDD$$$$DDD$$$$$$DDDDDDDDDDDD$$$$$$$DDD$$$$$DDDD                                  DDNDDDIIIIIDDD    
--     .DDDD   DD,,,,DN  DD,,,,DD                                                .D.  DDDD$$$$$$$$$$$$DDDD$$$$$$DDDD$$$$$$$$$$$$$$$$$$$$$$$$$$DDDDZDD+.                                  DDIIIDDDI8DD      
--     DD,,DD. DD,,,,,D  ID,,,,DD                                                .DDDDD$$$$$$$$$$$8DDDDD,DDD$$$$$$$DD$$$$$$$$$$$ODDDDDDDDDDD$$$$$DDD?.8.                               DD8IIIIIIDDD.       
--     DN,,,DD .DD,,,,DD  D,,,,ND                                                 DD$$$$$$$$$$$$$DD8$$DD,,,DD$$$$$$$DNDDDDDDDDDDD$$$$$$$$$$$ZDDO$$$$$DD                              8DDIIIIIIIDD.         
--     DD,,,,DD ID,,,,DD. D,,,,8D                                                ND$$$$$$$$$$$$DDDD$$$DD,,,,DDD$$$$$$$$$$$$$$$$$$$$$$DDDDD$$$$$ZODDD8                               DDIIIIIIIIDD           
--      DD,,,,DD DD,,,,DD ND,,,,DD                                               DD$$$$$$$$$$DDD$DDD$$NN,,,,,,DD$$$$$$$$$$$$$$$DDDDDDDDDODDDDD$$$$8DDDDD                          .ND8IIIIIIDDD.           
--       DD,,,DD.DD,,,,ND..D,,,,DD     DDDDDD.                                   .DD$$$$$$$$DD$$$DDDD$DD,,,,,,,DDDDD$$8DDDDDDDDDZ,,DD$$D$$D$DDDDD$$$$DD                          DDNIIIIIIIND              
--       DD,,,,DD DD,,,,DD.D,,,,DD.   ND,,,,DD                                    +D8$$$$DDDDDD$$DD,DDDD,,,,,,,,DDZDDDDDNDI,,,,,,,,$DD$DDOD$DD .DDDDNN                          .DDIIIIIIODD               
-- :DDDD  DD,,,,DD DD,,,=D D,,,,,DO .DD,,,,,DD                                     +DD8DDD8$$DDD$DD,,DD,,,,,,,,,,,,,,,,,,~DDDDDDDD,,,D8$D$DOD.                                .DD8IIIIIIDN,                
-- D,,,DD..DD,,,,DDDD,,,,DDD,,,,,DD DD,,,,,DD.                                       DDDD8$$$DDDDDD,,,DDDDDDD,,,,,,,,,,DDDDDO  NDDDD,8NDD$NDDDD                              DD8IIIIIIIDD                  
-- DD,,,DD  DD,,,DD.DD,,,,,,,,,,,DD D,,,,,DD+                                           DD8$$DD,DND,DDDDDDDDDDDD,,,,,,DDD        .DDD,DDDDD,,,DD                           .DDIIIIIII7DD                   
-- DD~,,,DD .D$,,,DDDD,,,,,,,,,,,:DD,,,,,,DD                                             DDD$8DD,,DDDDI     . DDDO,,,NDD           .DDNDDD,,D,DD                         .DDDIIIIIIIDDD.                   
--  DD,,,,DD. D,,,,,Z,,,,,,,,,,,,DDD,,,,,DD                                           . .8DDD$DD,,DDD           DD,,=DDD    .DD.    DDDDDD,D,,DD                       . DNIIIIIIIIDDZ                     
--   DD,,,,DD+DD,,,,,,,,,,,,,,,$DD,,,,,,,DD                                            DDD$7DDDD,DDD.           DDDDDDD     DDDD    DDDND,ZD+DD.                       .DDIIIIIIINDD                       
--    DD,,,,DDDDD,,,,,,,,,,,,,DD,,,,,,,,DD                                             DD,,,,DDDNDDN    DDD.    ~DDDDDD?     DD     DD,DD,DND$                        DDDIIIIII7DD                         
--     DD,,,,,DN,,,,,,,,,,,,,ND,,,,,,,,,DD                                             DD?,DD,DDDDDD    DDD     DDD,,ZDD           DDD,DD,DD~                       .DDIIIIIIIDDD                          
--      DD,,,,,,,,,,,,,,,,,,DD,,,,,,,,,,DD                                              8DZ,DD,DD,DD     .      DDD,,,DDD8        DDD,DD,,DD.                      DD8IIIIIIIDD?  .                        
--       DD,,,,,,,,,,,,,,,,,DD,,,,,,,,,,DD                                               .DDDD,DD,DDDO         DDD,,,,,=DDDD.  ?DDDD,,DD,,DD                     8DDDIIIIII8DD                             
--        .DD,,,,,,,,,,,,,,,,,,,,,,,,,,,DD                                                 .DDO,DD,DDDDI     DDDD,,,,,,,,DDDDDDDDD,,,,DD,,DD                     DDIIIIIIIDDD                              
--         DDN,,,,,,,,,,,,,,,,,,,,,,,,=DD                                                    DD,,DD,,DDDDDDDDDD,,,,,,,,,,,,,,,,,,,,,,=DO,=D                    DDDIIIIIIIDD                                
--           DD,,,,,,,,,,,,,,,,,,,,,,DDD                                                      DD,DN,,,,,DD,,,,,,,,,,,,,~DD,,,,,$D,,,,~D:,,D.                  DD7IIIIII8DD .                               
--            ND,,,,,,,,,,,,,,,,,,,,DD.                                                       DD,,DD,,,,,,,,,,,,DDDDDDDDD,,,,,,,DD,,,DD,,DD.                 NDIIIIIIIDD.                                  
--             DD,,,,,,,,,,,,,,,,,,DD.                                                         DD,=D$,,,,DD,,,,,,,,,,,,,,,,,,,DDDDD,,DDDDDD                ODDIIIIIIDDD.                                   
--              DDN,,,,,,,,,,,,,,,,DDDDD                                                       DD,,DN,,,?DDDD,,,,,,,,,,,,,,DDDD,,,,,,DD                   DDIIIIIIIDDD                                     
--             .  ND,,,,,,,,,,,DNDDDD..DD                                                       D8,DDD,,D,,,DDDDD+,DDDDNDDDDZ,,,,,,,,D.                  DDIIIIII$DD.                                      
--                 DDD,,,,NDDDDD       DD.                                                       DDDDD,,,,,,,,,IDDDDDDIZ+,,,,,,,,,,,ID.               .DDDIIIIIINDD                                        
--                   DDDDDDZ  .         DN                                                          .DD,,,,,,,,,,,,,,,,,,,,,,,,,,,,,DD.               DNIIIIIIINND                                         
--                  DDDDD.              .DD                                                          DD,,,,,,,,,,,,,,,,,,,,,,,,,,,,,DD              DD8IIIIIIIDD                                           
--                 DD                    DD                                                           DD,,,,,,,,,,,,,,,,,,,,,,,,,,,,DD            .DD7IIIIII7DD.                                           
--                  DD                    DD                                                          .DN,,,,,,,,,,,,,,,,,,,,,,,,,,8D,           DDDIIIIIIIDD,                                             
--                  DD              .   .$$DD                                                          DDI,,,,,,,,DDDIZD,DD,,,,,,,,D8 .         DDIIIIIIIDDN                                               
--                   ND         .  . $$$$$$DD..                                                         DD,,,,,,,,,,,,,,,,,,,,,,,,,ND         .DNIIIIIIIDD                                                 
--                   .DD        +$$$$$$$$$$$DD                                                          DN,,,,,,,,,,,,,,,,,,,,,,,,DD        .DDIIIIIII7DD.                                                 
--                    .DD  .I$$$$$$$$$$$$$$$DD                                                          .DD,,,,,,,,,,,,,,,,,,,,,,,DD.     .~DOIIIIIIINN                                                    
--                     DD$$$$$$$$$$$$$$$$$$$$DD.                                                         .DD,,,,,,,,,,,,,,,,,,,,,DD.     .DDIIIIIIIIND:                                                    
--                      DD$$$$$$$$$$$$$$$$$$$$DD                                                           DD,,,,,,,,,,,,,,,,,,DDD       DDIIIIIIIZND                                                      
--                      DD$$$$$$$$$$$$$$$$$$$$DDN                                                           DDD7,,,,,,,,,ZDDDDDD       .DDIIIIIIIDD7                                                       
--                       DD$$$$$$$$$$$$$$$$$$$$DD                                                             ~DDDDDDDDDDDDDDDDD      DDDIIIIIIIDD                                                         
--                        DD$$$$$$$$$$$$$$$$$$:.DD.                                                             DN,,,,,,,,,=DDDD     DDIIIIIIIDND                                                          
--                        DD$$$$$$$$$$$$$$$$     DD                                                             D,,,,,,,,,,,,,DD   DDDIIIIIIIDD                                                            
--                        ~DD$$$$$$$$$$....      DD                                                             DD,,,,,,,,,,,,DD  NDIIIIIII7DD                                                             
--                         DD$$$$$$. .            ND                                                            D,,,,,,,,,,,,,DDDDDIIIIIIIDD                                                               
--                          DD$.                  ND,                                                        .DDDDDNI,,,,,,,ZDDDDIIIIIIIIDD                                                                
--                          .D=                    DD                                                      NDND$$8DDDDDDDDDDDDDDIIIIIIIDN?                                                                 
--                           ND.                 .$$DD.                                               .DDDDD$$$$$$$$$$$$$$$$DDIIIIIIIIDDDN:.                                                               
--                            7D.             .$$$$$$D~                                         ,DDDDDDDDD$$$$$$$$$$$$$$$$DDDIIIIIIIDDDDDDDDD                                                              
--                            :D.       .$$$$$$$$$$$$DD.                                   ..DDDD$8$$$DD.$$$$$$$$$$$$$$$$DDDIIIIIIIDDDD$$$$ZDD7.                                                           
--                             DND  ..=$$$$$$$$$$$$$$$DD                               DDDDDD$$$$$$$$DD        .  ......DDIIIIIIIIDDD ..     .D?                                                           
--                              DD$$$$$$$$$$$$$$$$$$$$$DD                        NNDD+DO.   .$$$$$$$DD                 DDIIIIIIINDD           DN.                                                          
--                              .DD$$$$$$$$$$$$$$$$$$$$DD                    8DDDD..         $$$$$$8D?               DDDIIIIIIIDDD             DDD                                                         
--                               DD$$$$$$$$$$$$$$$$$$$$DD.             DDDDDD$$$$$$          .$$$$DDD               DD7IIIIIIIDD                 DD                                                        
--                                DD$$$$$$$$$$$$$$$$$$$$DD         DDDDD$$$$$$$$$$$.          $$$DD.               DDIIIIIIIDDD                  .DN                                                       
--                                 DD$$$$$$$$$$$$$$$$.  .DD..$8DDDD?  I$$$$$$$$$$$$I          ?$$DD             .NDDIIIIIIINDD                    +D.                                                      
--                                 .DD$$$$$$$$$$$$,.    DDDDDD8$.     .$$$$$$$$$$$$~          .$DD$.           DNDIIIIIIIZDD7                    ,$8DD                                                     
--                                  DD$$$$$$$$$..      . .$$$$$$      .$$$$$$$$$$$$$.          $DD$$$$$$$$.$$$DD7IIIIIIINDD . ...  .    ..I$$$$$$$$$$DD                                                    
--                                   D$$$$$$$.. .        $$$$$$$      .$$$$$$$$$$$$$$          DDO$$$$$$$$$$DDDIIIIIIINDD$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                    
--                                   DD$$$.            ..$$$$$$$       $$$$$$$$$$$$$$:         ND$$$$$$$$$DDDDIIIIIIZDD8$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD7 .                                                 
--                                   DD$7.           . 7$$$$$$$       .$$$$$$$$$$$$$$I         ND$$$$$$$$DD8IIIIIIIIDD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                   
--                                    DDZ            .=$$$$$$$$        $$$$$$$$$$$$$$$I       ~D$$$$$$$$DDIIIIIIIINDD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                  
--                                     DD           $$$$$$$$$$.        .$$$$$$$$$$$$$$7 .     .DD$$$$$$DDIIIIIII7DDD$$$$$$$$$$$D$$$$$$$$$$$$$$$$$$$$$$$DD                                                  
--                                     ?DN         .$$$$$$$$$$.        .$$$$$$$$$$$$$$$.      DD$$$$$DDDIIIIIINDDD$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$$DO                                                 
--                                      DD        $$$$$$$$$$$$          $$$$$$$$$$$$$$$:.     DD$$$$DDIIIIIIIDDD$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$$DD=                                                
--                                       DD     .$$$$$$$$$$$$:          .$$$$$$$$$$$$$$$.    ?DD$$DDD8IIIIIIDD$$$$$$$$$$$$$$$$DDD$$$$$$$$$$$$$$$$$..     DD                                                
--                                       .D.   $$$$$$$$$$$$$$.          .$$$$$$$$$$$$$$ODNDDDDDDDDDNIIIIIIIDD$$$$$$$$$$$$$$$$$DDD$$$$$$$$$$$...  .       ND                                                
--                                        DD  $$$$$$$$$$$$$$$            $$$$$$$DDDDDDDD Z,   .DDNIIIIIIINDD     .           .DDD                        OD                                                
--                                         DDI$$$$$$$$$$$$$$$            $$$8DDDD..           DD$IIIIIIIDDD                  DDDDD                        D                                                
--                                         +DD$$$$$$$$$$$$$$$   . .D.NDDDDDDDD               DD7IIIIIIDDD.                 .DDDDDD.                       DD                                               
--                                            DDD$$$$$$$$$$$$ DDDDDDDD..                    DD7IIIIIIZDD                    DD.DDDD                       ND                                               
--                                              .DDDDDDDDDDDDDD~?                         DDOIIIIIIIDDD                          DD .                     DD                                               
--                                                  ,Z~DID7                              NDOIIIIIIINDN                            DD.                  ...DD                                               
--                                                                                     DDDIIIIIIIIDD. .                           DD.             I$$$$$$$$DD                                              
--                                                                                   .DDNIIIIIIINDD$$$$$...+II. .. ..... ..  .....7DD...==$$$$$$$$$$$$$$$$$DD.                                             
--                                                                         Z7DD     DDD$IIIIII7DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$DD.                                             
--                                                                      ,DDDDDDDDDDDDDIIIIIIIDDD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$$DD                                             
--                                                                     DD:,,,,,,,,~DDDIIIIIIDDDD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$DD                                             
--                                          DDDDD$                   ,DDDDDDDDD,,,,,,DDNIIDDD DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$$D?                                            
--                                        DDDIIIIDD .              DDDD,,,,,,~DDD,,,,,?DDDDO  DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$DD.                                           
--                                      .DNIIIIII$D              . D?,,,,,,,,,,,DN,,,,,,DDD.  DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$DD                                            
--                                     .DDIIIIIIIDD               DDDDDDDDD,,,,,,,,,,,,,,,ND .DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$$$$$$DD.                                           
--                                    DDDIIIIIIIIND             ODDDD,,,,,NDD,,,,,,,,,,,,,,DD.D..$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD$$$$$$$$$$$$$$$$$..  7D                                            
--                                    DDIIIIII7DD.             DDI,,,,,,,,,,,,,,,,,,,,,,,,,,DDDD,      .. ......7$,.....$$$.=.,$:. .,$DD$$$.$$.......        DD                                            
--                                   DDIIIIIIDDD.             ?D,IDDDDZ,,,,,,,,,,,,,,,,,,,,,,DD :DDD?                                  DD..                  .ND                                           
--                                  DDIIIIIIID.               DDDDDZI8DDD=,,,,,,,,,,,,,,,,,,:D .  . ODDDD                              DD                     7D:                                          
--                                  DNIIIIIIDD              ..DD7,,,,,,,,,,,,,,,,,,,,,,,,,,,DD         . DDDDD .                       $D=.                    DD                                          
--                                 DDIIIIIIZD..             NDD,,,,,,,,,,,,,,,,,,,,,,,,,,,,DD            .$$$DDDDDD.                   .DD.                    DN                                          
--                                 DDIIIIIIDD               DD,,,8DDD,,,,,,,,,,,,,,,,,,,,,,DN            .$$$$$$$$DDDDDD+..    .        .DD                   .ND                                          
--                                 DNIIIIIIDN               DDD,DDDDDDDD~,,,,,,,,,,,,,,,,,DD.           =$$$$$$$$$$$$$$$DDDDDNDD        ~DD                    ZD~                                         
--                                 DDIIIIIINN                ?DDDDIIIIDDDDD,,,,,,,,,,,,,,DD.           .$$$$$$$$$$$$$$$$     .DDDDDDD ...DD.           ....,,.$$DD                                         
--                                 DNIIIIIIND.                DDIIIIIIIDDDDDDD,,,,,,,,,,DDD            $$$$$$$$$$$$$$$$.       .   DDDDDDDDDD..  ..:$,$$$$$$$$$$DN                                         
--                                 IDIIIIIIIDD  .           DDNIIIIIIINDD   .DDDDDD,,,,DDD~          .,$$$$$$$$$$$$$$$$            .$$$$$$$.DNDDDO$$$$$$$$$$$$$$$DN                                        
--                                 NNIIIIIIIIDD            D8IIIIIIIIDD.         ?DDDDDDDD           .$$$$$$$$$$$$$$$$             :$$$$$$$$. ..$$$$$$$$$$$$$$$$$D.                                        
--                                  DDIIIIIIIIDD. .      DDDIIIIIIIIDN .                D.          .,$$$$$$$$$$$$$$$$             ~$$$$$$$$     ?$$$$$$$$$$$$$$$DD                                        
--                                   D7IIIIIIIIDDDDDDDDDD8IIIIIIIIDDO.                 DD.          ,$$$$$$$$$$$$$$$$$            .$$$$$$$$$?..    =$$$$$$$$$$$$$D.                                        
--                                   ODDIIIIIIIIIIIIIIIIIIIIIIIIIDD.                    DDD         $$$$$$$$$$$$$$$$$.          . .$$$$$$$$$$:      .$$$$$$$$$$$$DI                                        
--                                    .DNIIIIIIIIIIIIIIIIIIIIIINDD                       . DDDD .  .$$$$$$$$$$$$$$$$.            .$$$$$$$$$$$..     ..$$$$$$$$$$DDD                                        
--                                      =DDDIIIIIIIIIIIIIIIIIIDD=                            DDDDDD8O$$$$$$$$$$$$$$.            ..$$$$$$$$$$$I.      . ,$$$$$$$$DD                                         
--                                        +DDDDIIIIIIIIIIIODDDD                              DD$$$$$DDD8$$$$$$$$$$$.             $$$$$$$$$$$$$.          $$$$$$DDD                                         
--                                            DDDDDDDDDDDDDN                                 DD,...+$$$D.DDDD8$$$$$.            .$$$$$$$$$$$$$$.           $$$$NO                                          
--                                                  .7DI                                     =D            . $DDDD,              $$$$$$$$$$$$$$            .$$DDI                                          
--                                                                                           DD                  .DDDDD        .$$$$$$$$$$$$$$$              $D                                            
--                                                                                           7D                      .?7NDDDDD..$$$$$$$$$$$$$$$             DDN                                            
--                                                                                           DD                            ..DDDDDDN$$8$$$$$$$$.          DDD                                              
--                                                                                           D.                                  .DDDDDDDDDDD88$, DD.DDDDDN.                                               
--                                                                                           .D                                       .NDDDDDDDDDDDDDDD                                                    
--                                                                                           DD$$$$...    .  ...                        . .$DDDDDDD                                                        
--                                                                                           ,D$$$$$$$$$$$$$$$$$$$$?.I$$$$$$$$$$$$$$$$$$$..$$,8DDDN                                                        
--                                                                                            D$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$D                                                        
--                                                                                           DD$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           DD....=$$$$$:I$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$DD                                                        
--                                                                                           ND              .       .        .  .         .    .N,                                                        
--                                                                                           DD                                                  D                                                         
--                                                                                           DD                                                 .DD                                                        
--                                                                                           DD                                                 ID                                                         
--                                                                                           DD                                                 DD.                                                        
--                                                                                           DD                                                 :DD                                                        
--                                                                                           DD$ .                                              .D~                                                        
--                                                                                            DDDDDDDDDDO                                 .     :DD                                                        
--                                                                                            DDDND77DDNDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD                                                         
--                                                                                            DD7DD7DD7777777DDD7777DDDDD$DD78D777Z87777ZO77DNDDDD                                                         
--                                                                                            DDIDD7DD7777777DDO7777DN77777777777777777777777777ND                                                         
--                                                                                            DD7D87DD7777777ZD77777DD77777777777777777777777777DD                                                         
--                                                                                            D$7D77DD77777777D87777DD77777777777777777777777777DD                                                         
--                                                                                           ~D77D77DD77777777DD7777DD77777777777777777777777777DD                                                         
--                                                                                            DO7D77DD77777777DD7777DD77777777777777777777777777DD                                                         
--                                                                                            D7$D$7DD77777777DD77777DD7777777777777777777777777DD                                                         
--                                                                                           DD7ODO7DD777777777DD7777DD7777777777777777777777777$D                                                         
--                                                                                           DD7$DO7DD777777777DDD777$DD7777777777777777777777777D~                                                        
--                                                                                            D77DD7DD7777777777DD7777DDD777777777777777777777777D.                                                        
--                                                                                           .D77DD7DD7777777777DD77777DDD7777777777777777777777DD.                                                        
--                                                                                           DD77ND7DD77777777777DD777777DDD777777777777777777777DD                                                        
--                                                                                           .DO7DD7DD77777777777$DD7777777DDDND77IOD877777777777DD                                                        
--                                                                                           .DZ7DD7DD7777777777777DDD77777777$DDDDDDDD777777777DD                                                         
--                                                                                           .D77DD7DD77777777777777DDZ7777777777777ZDO777777777DN                                                         
--                                                                                            DD7DD7DD777777777777777DDDN77777777777DD7777777777DD                                                         
--                                                                                            DD7DD7DD777777777777777777DDDDDDD777$DDD777777777DD                                                          
--                                                                                            ND7DD7DD7777777777777777777777Z8DDDDDDDD777777777DD                                                          
--                                                                                            ND7DDDD77777777777777777777777777777777777777777DD                                                           
--                                                                                             DD7DDD7777777777777777777777777777777777777777DD.                                                           
--                                                                                             DDDDDD777777777777777777777777777777777777777$DN                                                            
--                                                                                             DD$DDD777777777777777777777777777777777777777DD                                                             
--                                                                                             DDDDD777777777777777777777777777777777777777DD.                                                             
--                                                                                              DDDD77777777777777777777777777777777777777DD                                                               
--                                                                                             .DDD777777777777777777777777777777777777777DZ                                                               
--                                                                                              DDD77777777777777777777777777777777777777DD                                                                
--                                                                                              8D77777777777777777777777777777777777777DD.                                                                
--                                                                                              DN7777777777777777777777777777777777777DD.                                                                 
--                                                                                              DD777777777777777777777777777777777777DDD                                                                  
--                                                                                             DD7777777777777777777777777777777777777NDD:                                                                 
--                                                                                             DD777777777777777777777777777777777777DDDDD                                                                 
--                                                                                             D$77777777777777777777777777777777777ODDDDDD                                                                
--                                                                                           8DD777777777777777777777777777777777777DDDDDDD                                                                
--                                                                                           DD777777777777777777777777777777777777DDDDDDDD+                                                               
--                                                                                           DD77777777777777777777777777777777777$DDDDDDDDD                                                               
--                                                                                          .DD77777777777777777777777777777777777DDDDDDDDDD7                                                              
--                                                                                          DD77777777777777777777777777777777777DDDDDDDDDDDD                                                              
--                                                                                         .DD7777777777777777777777777777777777DDDDDDDDDDDODZ                                                             
--                                                                                         DD77777777777777777777777777777777777DDDDDDDDDD77DD                                                             
--                                                                                         DD7777777777777777777777777777777777DDDDDDDDD7777DD                                                             
--                                                                                        .N77777777777777777777777777777777777DDDDDDDD77777DD.                                                            
--                                                                                        DDI777777777777777777777777777777777DDDDDDDD7777777DD.                                                           
--                                                                                       ~D77777777777777777777777777777777777DDDDDDD777777777D7                                                           
--                                                                                       DD7777777777777777777777777777777777DDDDDDD7777777777DDD                                                          
--                                                                                       ND777777777777777777777777777777777ODDDDDD777777777777DD                                                          
--                                                                                      ?D7777777777777777777777777777777777DDDDDD7777777777777ODD                                                         
--                                                                                      DD777777777777777777777777777777777DDDDDD777777777777777DD                                                         
--                                                                                     =D7777777777777777777777777777777777DDDDD7777777777777777DD=                                                        
--                                                                                     .DZ777777777777777777777777777777777DDDDD77777777777777777DD                                                        
--                                                                                    DDD7777777777777777777777777777777777DDDD777777777777777777$D.                                                       
--                                                                                    DD7777777777777777777777777777777777DDDD77777777777777777777DD                                                       
--                                                                                   .D7777777777777777777777777777777777DDDD777777777777777777777$DD                                                      
--                                                                                   DD777777777777777777777777777777777DDDD77777777777777777777777DD                                                      
--                                                                                   D877777777777777777777777777777777DDDDD777777777777777777777777DN                                                     
--                                                                                 .DD777777777777777777777777777777777DDDD7777777777777777777777777DDZ                                                    
--                                                                                  DD777777777777777777777777777777777DDD777777777777777777777777777DD                                                    
--                                                                                 DD777777777777777777777777777777777DDDD777777777777777777777777777DD                                                    
--                                                                                 DN777777777777777777777777777777777DDD77777777777777777777777777777DD.                                                  
--                                                                               .DD77777777777777777777777777777777ODDDD777777777777777777777777777777DD.                                                 
--                                                                                DD77777777777777777777777777777777DD.DD777777777777777777777777777777DD.                                                 
--                                                                               .DD7777777777777777777777777777777DDD :DN777777777777777777777777777777DD                                                 
--                                                                               DD77777777777777777777777777777777ND   DD777777777777777777777777777777ZD.                                                
--                                                                              ~D777777777777777777777777777777777DD   .DD77777777777777777777777777777DD.                                                
--                                                                               D$7777777777777777777777777777777DD.     DD77777777777777777777777777777ODD                                               
--                                                                              DN77777777777777777777777777777777DD      DN777777777777777777777777777777DD                                               
--                                                                             ~D77777777777777777777777777777777DD       ~DD777777777777777777777777777777DD                                              
--                                                                             DN7777777777777777777777777777777DD.        DD777777777777777777777777777777DDO                                             
--                                                                             DD7777777777777777777777777777777DN.         DN777777777777777777777777777777DD7                                            
--                                                                            ND7777777777777777777777777777777DD.          .DD777777777777777777777777777777DD.                                           
--                                                                            D7777777777777777777777777777777DD            .DN777777777777777777777777777777DD                                            
--                                                                          .DD77777777777777777777777777777777D~            DN777777777777777777777777777777$D:                                           
--                                                                          DD77777777777777777777777777777777DD              DD777777777777777777777777777777DDD                                          
--                                                                          DD7777777777777777777777777777777DD               .DD777777777777777777777777777777DD                                          
--                                                                         DD77777777777777777777777777777777DD               .DD7I77777777777777777777777777777DN                                         
--                                                                         DD77777777777777777777777777777777DD                 DDI777777777777777777777777777777ND                                        
--                                                                        DD77777777777777777777777777777777DD.                  DD777777777777777777777777777777DD.                                       
--                                                                        DD7777777777777777777777777777777DD.                    DD777777777777777777777777777777DD.                                      
--                                                                        DD7777777777777777777777777777777DD.                    DD777777777777777777777777777777$D                                       
--                                                                       ~DZ777777777777777777777777777777DD .                   .DD7777777777777777777777777777777D..                                     
--                                                                       DD7777777777777777777777777777777DD .                    .DDD77777777777777777777777777777DDD                                     
--                                                                      DDZ7777777777777777777777777777777DD                        DD777777777777777777777777777777DN                                     
--                                                                      DD7777777777777777777777777777777DND                         DD777777777777777777777777777777DD                                    
--                                                                     DD7777777777777777777777777777777DD                           .D7777777777777777777777777777777DD                                   
--                                                                     ND7777777777777777777777777777777DD                            DD777777777777777777777777777777DN                                   
--                                                                     DD777777777777777777777777777777DD                             .DD777777777777777777777777777777DD                                  
--                                                                     DD777777777777777777777777777777DD                               DD77777777777777777777777777777DD8                                 
--                                                                  . DD777777777777777777777777777777DD.                               DD777777777777777777777777777777DD                                 
--                                                                   .D8777777777777777777777777777777DD                                DDZ77777777777777777777777777777DD                                 
--                                                                   DD7777777777777777777777777777777D~                                 ~DO77777777777777777777777777777DD                                
--                                                                  DD8777777777777777777777777777777DD                                   DD777777777777777777777777777777DD                               
--                                                                  ND7777777777777777777777777777777DD                                   .DD777777777777777777777777777777D.                              
--                                                                 DDD777777777777777777777777777777DD                                     DD777777777777777777777777777777DD                              
--                                                                 DD777777777777777777777777777777DD                                       DD77777777777777777777777777777OD.                             
--                                                                 DD777777777777777777777777777777DD                                       .DD77777777777777777777777777777DD.                            
--                                                                DD7777777777777777777777777777777DI                                       .DD77777777777777777777777777777DDD                            
--                                                               DD7777777777777777777777777777777DD                                         DD777777777777777777777777777777DD                            
--                                                               DD777777777777777777777777777777DD                                          .DD777777777777777777777777777777ND.                          
--                                                              .DDI77777777777777777777777777777DD                                            DD777777777777777777777777777777DD                          
--                                                              DD777777777777777777777777777777DDD                                            ,DD777777777777777777777777777777DD                         
--                                                             .D7777777777777777777777777777777DD                                              DD777777777777777777777777777777DD                         
--                                                             DD7777777777777777777777777777777DN.                                              DD77777777777777777777777777777DD                         
--                                                             DN777777777777777777777777777777DN:                                              .DD777777777777777777777777777777ND                        
--                                                            .DZ77777777777777777777777777777DD                                                 DD7777777777777777777777777777777DN                       
--                                                           DND777777777777777777777777777777ND.                                                .DD777777777777777777777777777777ON.                      
--                                                          .DO7777777777777777777777777777777DD                                                   DD777777777777777777777777777777DD.                     
--                                                          .DD7777777777777777777777777777777D.                                                    DD777777777777777777777777777777DN                     
--                                                          $D7777777777777777777777777777777DD                                                     ZDD77777777777777777777777777777DD.                    
--                                                          DD777777777777777777777777777777DD                                                       DD777777777777777777777777777778DD                    
--                                                         DDO777777777777777777777777777777DD.                                                      DD7777777777777777777777777777777DD                   
--                                                         DD777777777777777777777777777777DD                                                         DD777777777777777777777777777777ND.                  
--                                                        DD7777777777777777777777777777777D~                                                        . DD777777777777777777777777777777DD.                 
--                                                       .DN777777777777777777777777777777DD                                                           ND777777777777777777777777777777DDN                 
--                                                       DD7777777777777777777777777777777DD                                                            DD777777777777777777777777777777DD                 
--                                                       DD777777777777777777777777777777DD                                                              DD77777777777777777777777777777DDD                
--                                                      .DD777777777777777777777777777777DD                                                               D$77777777777777777777777777777$DD               
--                                                     ~DD777777777777777777777777777777DD                                                                D7777777777777777777777777777777DD               
--                                                     DD777777777777777777777777777777$D~                                                                DDD777777777777777777777777777777DD              
--                                                     DD777777777777777777777777777777DD.                                                                 DD77777777777777777777777777777I7DZ             
--                                                     DD77777777777777777777777777777DDN.                                                                 .DD777777777777777777777777777777DD             
--                                                    DD777777777777777777777777777777DD                                                                    .DD777777777777777777777777777777DN            
--                                                    D7777777777777777777777777777777DD.                                                                     D$77777777777777777777777777777DD            
--                                                   DD777777777777777777777777777777DD                                                                      .D77777777777777777777777777778DDD            
--                                                  .D$777777777777777777777777777777DD                                                                       NDD7777777777777777777777777DDDDDN.          
--                                                  DD7777777777777777777777777777777D7                                                                        ~D7777777777777777777777NDDDIIIIDDD         
--                                                 ?DZ7777777777777777777777777777777DD                                                                        .DD7777777777777777777ODDIIIIIIII7DD        
--                                                 DD7777777777777777777777777777778DD                                                                          .DD77777777777777ODNDDIIIIIIIIIIIDDD       
--                                                .D7777777777777777777777777777777DD                                                                            DD77777777777DDDDNIIIIIIIIIIIIIIIIDN      
--                    .                           DD7777777777777777777777777777777D.                                                                             DN77DDDDDDDDDIIIIIIIIIIIIIIIIIIIIDD      
--             .DDDDDDDDDDD~.                    .DD777777777777777777777777777777DD                                                                              NDDDDDDDOIIIIIIIIIIIIIIIIIIIIIIIIIDD     
--            DDDIIIIIIIIIDDDDDDDDDDNNDDD7DDDDDDDDDDDDD77777777777777777777777777DD                                                                             .DDDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDDD    
--           .DDIIIIIIIIIIIIIIIIIIINIIIIDDIDDIIDNDDNDDDDDZ77777777777777777777777DD                                                                            =DD87IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDDDZDD   
--           DDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIODDDDDD777777777777777777777DD                                                                           DNDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDDIIIIDD  
--          DDIDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDDDDDD7777777777777777DD                                                                        . DDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDDDNIIIIIDD. 
--          DDIIZDD$IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIZ8DDD77777777777777D                                                                          DDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIZODDDIIIIIIIIID. 
--         .DDIIIIDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIINDDDDDD7777777DD                                                                        DDNIIIIIIIIIIIIIIIIIIIIIIIIIIIDDDNDNIIIIIIIIIIDD  
--          .D8IIII7DDDOIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII8DDDDDDDDD.                                                                      DDDOIIIIIIIIIIIIIIIIIIIIIIIINDDDDIIIIIIIIIIII8DDD   
--           +DDIIIIIINDDD8IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDDDDD                                                                      .DD$IIIIIIIIIIIIIIIIIIIIIII7DDNN8IIIIIIIIIIIINDDZ     
--             DDDIIIIIIINDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII7DN                                                                    DDDNIIIIIIIIIIIIIIIIIIIIIIIDDDNIIDDIIIIIIIIIDDDD..      
--               DDDIIIIIIIIDDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDD                                                                DDDDDIIIIIIIIIIIIIIIIIIIIIIIZ$DDIIIIDDDDIIIIIDNNND          
--                7DDDNIIIIIIIIIDDDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDD                                                           .DDDDDIIIIIIIIIIIIIIIIIIIIIIIIIIDDNDIIINDD DDNIDDDN              
--                    DNZIIIIIIIIIIIIDDDDDNDDD8IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIDD                                                           DDIIIIIIIIIIIIIIIIIIIIIIIIII8DNDDIIIIIDDD   ,DDD                 
--                    .:DDDNIIIIIIIIIIIIIZDD8NDDDDDDDDIIIIIIIIIIIIIIIIIIIIIIIDD                                                          DDIIIIIIIIIIIIIIIIIIIIIIIIIDDD8IIIIII7DD,.                        
--                        DDDDDDDDIIIIIIIIIIIIIIIIIIIDDDDDIIIIIIIIIIIIIIIIIIDD                                                           DDIIIIIIIIIIIIIIIIIIIIIINDDDIIIIIIIIIDD.                          
--                           ..DDDDDDDDDDIZ$IIZ$IIIIIIIDNNDDDDDIIIIIIIIIIIIIDD                                                           NNIIIIIIIIIIIIIIIIIDDDDDD8IIIIIIIIDDDD.                           
--                                . .I..DDDDDDDNDDDDDDIIIIIODIDDDDDDDDDDIIIIDD                                                          .DIIIIIIIIN8ODDDDDDDDZIIIIIIIIIIIDDD                               
--                                                  DNIIIIIIIIIIIIIIIIIDDDDDDD                                                          .NDDDDDDDDNDDNIIIIIIIIIIIIIIIIIDDD                                 
--                                                  DNIIIIIIIIIIIIIIIIIIIIIDD                                                            NDIIIIIIIIIIIIIIIIIIIIII8DDDDD$                                   
--                                                  DDDD$IIIIIIIIIIIIIIIIIIDD                                                            +DDIIIIIIIIIIIIINDDDDDDDDD+D.                                     
--                                                   .  DDDNOIZIIIIIIIIIIIDD                                                               DDDNDDDDDDDDDDD.7..                                             
--                                                         7NDDDDDDDDDDDDDD                                                                    .O .  .                                                     
--                                                                .  ..ZD.                                                                                                                                 
--                                                                                                                                                                                          
-- generated with  :¬D GlassGiant.com

	--other layers
	local lay_num=1
	local img_other={}
	local img_other_quad={}
	local other_layer={}
	local tmp
	local tmp_img
	local tmp_img_quad

	local img_174 = love.graphics.newImage(map_path(name, "layer_174.png"))
	local img_quad_174 = love.graphics.newQuad(
		0, 0, img_174:getWidth(), img_174:getHeight(), img_174:getWidth(), img_174:getHeight())
	local layer_174 = Object(0, 174, 0) -- High z-value ==> on bottom
	function layer_174.draw()
		love.graphics.draw(img_174, img_quad_174, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_174)

	local img_195 = love.graphics.newImage(map_path(name, "layer_195.png"))
	local img_quad_195 = love.graphics.newQuad(
		0, 0, img_195:getWidth(), img_195:getHeight(), img_195:getWidth(), img_195:getHeight())
	local layer_195 = Object(0, 195, 0) -- High z-value ==> on bottom
	function layer_195.draw()
		love.graphics.draw(img_195, img_quad_195, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_195)

	local img_232 = love.graphics.newImage(map_path(name, "layer_232.png"))
	local img_quad_232 = love.graphics.newQuad(
		0, 0, img_232:getWidth(), img_232:getHeight(), img_232:getWidth(), img_232:getHeight())
	local layer_232 = Object(0, 232, 0) -- High z-value ==> on bottom
	function layer_232.draw()
		love.graphics.draw(img_232, img_quad_232, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_232)


	local img_254 = love.graphics.newImage(map_path(name, "layer_254.png"))
	local img_quad_254 = love.graphics.newQuad(
		0, 0, img_254:getWidth(), img_254:getHeight(), img_254:getWidth(), img_254:getHeight())
	local layer_254 = Object(0, 254, 0) -- High z-value ==> on bottom
	function layer_254.draw()
		love.graphics.draw(img_254, img_quad_254, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_254)


	local img_286 = love.graphics.newImage(map_path(name, "layer_286.png"))
	local img_quad_286 = love.graphics.newQuad(
		0, 0, img_286:getWidth(), img_286:getHeight(), img_286:getWidth(), img_286:getHeight())
	local layer_286 = Object(0, 286, 0) -- High z-value ==> on bottom
	function layer_286.draw()
		love.graphics.draw(img_286, img_quad_286, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_286)

	local img_319 = love.graphics.newImage(map_path(name, "layer_319.png"))
	local img_quad_319 = love.graphics.newQuad(
		0, 0, img_319:getWidth(), img_319:getHeight(), img_319:getWidth(), img_319:getHeight())
	local layer_319 = Object(0, 319, 0) -- High z-value ==> on bottom
	function layer_319.draw()
		love.graphics.draw(img_319, img_quad_319, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_319)

	local img_329 = love.graphics.newImage(map_path(name, "layer_329.png"))
	local img_quad_329 = love.graphics.newQuad(
		0, 0, img_329:getWidth(), img_329:getHeight(), img_329:getWidth(), img_329:getHeight())
	local layer_329 = Object(0, 329, 0) -- High z-value ==> on bottom
	function layer_329.draw()
		love.graphics.draw(img_329, img_quad_329, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_329)

	local img_333 = love.graphics.newImage(map_path(name, "layer_333.png"))
	local img_quad_333 = love.graphics.newQuad(
		0, 0, img_333:getWidth(), img_333:getHeight(), img_333:getWidth(), img_333:getHeight())
	local layer_333 = Object(0, 333, 0) -- High z-value ==> on bottom
	function layer_333.draw()
		love.graphics.draw(img_333, img_quad_333, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_333)

	local img_359 = love.graphics.newImage(map_path(name, "layer_359.png"))
	local img_quad_359 = love.graphics.newQuad(
		0, 0, img_359:getWidth(), img_359:getHeight(), img_359:getWidth(), img_359:getHeight())
	local layer_359 = Object(0, 359, 128) -- High z-value ==> on bottom
	function layer_359.draw()
		love.graphics.draw(img_359, img_quad_359, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_359)

	local img_339 = love.graphics.newImage(map_path(name, "layer_339.png"))
	local img_quad_339 = love.graphics.newQuad(
		0, 0, img_339:getWidth(), img_339:getHeight(), img_339:getWidth(), img_339:getHeight())
	local layer_339 = Object(0, 339, 0) -- High z-value ==> on bottom
	function layer_339.draw()
		love.graphics.draw(img_339, img_quad_339, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_339)

	local img_348 = love.graphics.newImage(map_path(name, "layer_348.png"))
	local img_quad_348 = love.graphics.newQuad(
		0, 0, img_348:getWidth(), img_348:getHeight(), img_348:getWidth(), img_348:getHeight())
	local layer_348 = Object(0, 348, 0) -- High z-value ==> on bottom
	function layer_348.draw()
		love.graphics.draw(img_348, img_quad_348, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_348)

	local img_353 = love.graphics.newImage(map_path(name, "layer_353.png"))
	local img_quad_353 = love.graphics.newQuad(
		0, 0, img_353:getWidth(), img_353:getHeight(), img_353:getWidth(), img_353:getHeight())
	local layer_353 = Object(0, 353, 0) -- High z-value ==> on bottom
	function layer_353.draw()
		love.graphics.draw(img_353, img_quad_353, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_353)

	local img_354 = love.graphics.newImage(map_path(name, "layer_354.png"))
	local img_quad_354 = love.graphics.newQuad(
		0, 0, img_354:getWidth(), img_354:getHeight(), img_354:getWidth(), img_354:getHeight())
	local layer_354 = Object(0, 354, 0) -- High z-value ==> on bottom
	function layer_354.draw()
		love.graphics.draw(img_354, img_quad_354, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_354)

	local img_363 = love.graphics.newImage(map_path(name, "layer_363.png"))
	local img_quad_363 = love.graphics.newQuad(
		0, 0, img_363:getWidth(), img_363:getHeight(), img_363:getWidth(), img_363:getHeight())
	local layer_363 = Object(0, 363, 0) -- High z-value ==> on bottom
	function layer_363.draw()
		love.graphics.draw(img_363, img_quad_363, 0, 0, 0, zoom)
	end
	table.insert(objects, layer_363)
-----------------------------------------


	-- Sort objects Most map objects are static. Thus pre-sorting them may
	-- speed up things a little or not. This could be investigated when needed.
	table.sort(objects, game_draw_order)

	function self.height(x, y)
		local x = math.floor(x / zoom)
		local y = math.floor(y / zoom)
		if x < 0 or x >= coldata_width or y < 0 or y >= coldata_height then
			return 0
		else
			local r, g, b, a = coldata:getPixel(x, y)
			return r -128
		end
	end

	function self.getName()
		return name
	end

	function self.getObjects()
		return objects
	end

	return self
end
