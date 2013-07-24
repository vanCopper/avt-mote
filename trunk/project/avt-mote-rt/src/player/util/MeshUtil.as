package player.util 
{
	/**
	 * ...
	 * @author blueshell
	 */
	public class MeshUtil
	{
		
		public static function genIndicesData(_indices : Vector.<int> , _vertexPerLine  : int, _totalLine : int): void
		{
			if (_indices)
			{
				_indices.length = 0;
				//indices = new Vector.<int>();
				
				for (var h : int = 1 ; h < _totalLine; h++ )
				{
					var _hLine : int = (h - 1) * _vertexPerLine;
					var _hLine2 : int = (h) * _vertexPerLine;
					for (var w : int = 1 ; w < _vertexPerLine ; w++ )
					{
						var p0 : int = _hLine + (w - 1);
						var p1 : int = p0 + 1;
						var p2 : int = _hLine2 + (w - 1);
						var p3 : int = p2 + 1;
						
						_indices.push(p0);
						_indices.push(p1);
						_indices.push(p2);
						
						_indices.push(p2);
						_indices.push(p1);
						_indices.push(p3);
					}
				}
			}
			
		}
		
	}

}