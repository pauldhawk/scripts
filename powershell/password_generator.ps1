 f u n c t i o n   G e n e r a t e - P a s s w o r d   {  
 	 p a r a m ( 	 [ P a r a m e t e r ( M a n d a t o r y = $ T r u e , P o s i t i o n = 1 ) ]  
 	 	 	 [ s t r i n g ] $ e m a i l  
 	 )  
 	 $ u s e r _ n a m e   =   ( $ u s e r _ n a m e   *   8 ) . s u b s t r i n g ( 8 , 8 )  
 	 $ r n d N u m b e r s   =   " 3 7 9 1 7 0 4 2 8 6 5 "  
 	 $ r n d L e t t e r s   =   " v x r f l m h o p u a w n g t q s d b e i k z j "  
 	 $ r n d S y m b o l s   =   " ! @ # $ % ^ < & * ( ) , ; : , . ? "  
 	 $ w k N u m b e r   =   g e t - d a t e   - U F o r m a t   % V  
 	 $ w k N u m b e r   =   g e t - d a t e   - U F o r m a t   % V  
  
 	 $ a r r   =   @ ( )  
 	 $ n a m e   =   $ u s e r _ n a m e . t o c h a r a r r a y ( )  
 	 $ n a m e N u m b e r   =   @ ( )  
 	 $ l e n   =   $ n a m e . l e n g t h  
 	 $ p s w d   =   " "  
 	 f o r   ( $ x = 0 ;   $ x   - l t   $ l e n ;   $ x + +   )   {   $ n a m e N u m b e r   + =   ( [ i n t ]   [ c h a r ] ( $ n a m e [ $ x ] )   +   $ x   +   $ w k N u m b e r )   }  
  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d L e t t e r s [ ( $ n a m e N u m b e r [ 0 ]   %   $ r n d L e t t e r s . L e n g t h ) ]  
 	 $ p s w d   =   $ p s w d . t o u p p e r ( )  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d S y m b o l s [ ( $ n a m e N u m b e r [ 1 ]   %   $ r n d S y m b o l s . L e n g t h ) ]  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d L e t t e r s [ ( $ n a m e N u m b e r [ 2 ]   %   $ r n d L e t t e r s . L e n g t h ) ]  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d S y m b o l s [ ( $ n a m e N u m b e r [ 3 ]   %   $ r n d S y m b o l s . L e n g t h ) ]  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d L e t t e r s [ ( $ n a m e N u m b e r [ 4 ]   %   $ r n d L e t t e r s . L e n g t h ) ]  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d N u m b e r s [ ( $ n a m e N u m b e r [ 5 ]   %   $ r n d N u m b e r s . L e n g t h ) ]  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d S y m b o l s [ ( $ n a m e N u m b e r [ 6 ]   %   $ r n d S y m b o l s . L e n g t h ) ]  
 	 $ p s w d   =   " { 0 } { 1 } "   - f   $ p s w d ,   $ r n d N u m b e r s [ ( $ n a m e N u m b e r [ 7 ]   %   $ r n d N u m b e r s . L e n g t h ) ]  
 	  
 	 $ o u t u p u t   =   " u s e r n a m e :   { 0 } ,   p a s s w o r d :   { 1 } "   - f   $ u s e r _ n a m e ,   $ p s w d  
 	 w r i t e - o u t p u t   $ o u t u p u t    
 	 r e t u r n   $ p s w d  
 }  
  
 G e n e r a t e - P a s s w o r d   - u s e r _ n a m e   "abck"
