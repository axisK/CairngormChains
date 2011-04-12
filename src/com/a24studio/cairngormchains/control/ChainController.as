package com.a24studio.cairngormchains.control {
	import com.a24studio.cairngormchains.chains;
	import com.adobe.cairngorm.control.FrontController;
	
	/**
	 * This class will use things in the internal chains namespace. Anything that is not declared
	 * as public, private or protected will be inside this namespace.
	 */
	use namespace chains;
	
	/**
	 * Controller implementation that registers the chain event to the chain command.
	 * If this is not done, events cannot be chained together.
	 * 
	 * @author Petrus Rademeyer
	 * @since 12 April 2011
	 */
	public class ChainController extends FrontController {
		/**
		 * Constructor implementation
		 */
		public function ChainController( ) {
			super( );
			addCommand( ChainEvent.CHAIN, ChainCommand );
		}
	}
}