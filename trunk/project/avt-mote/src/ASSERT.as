package  
{
	
	/**
	 * ...
	 * @author Blueshell
	 */
	
		//CONFIG::ASSERT 
		public function ASSERT (flag : Boolean , ...args):void{
			if (!flag)
				throw (""+args);
		}
	 
	 
	 

}