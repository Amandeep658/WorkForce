//
//  JobTypeCollectionViewCell.swift
//  WorkForce
//
//  Created by apple on 09/05/22.
//

import UIKit

class JobTypeCollectionViewCell: UICollectionViewCell {
 
 
    @IBOutlet weak var fullTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var selectedCell : Bool?{
        didSet{
            setSelected()
        }
    }
    
    
    
    func setSelected(){
        if( selectedCell == true){
            fullTimeLbl.backgroundColor = .white
            
        }else{
            fullTimeLbl.backgroundColor = .systemBlue
        }
    }
   
    
}
