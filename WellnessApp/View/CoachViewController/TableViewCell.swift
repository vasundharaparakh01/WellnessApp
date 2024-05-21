//
//  TableViewCell.swift
//  agora_n
//
//  Created by Nilanjan Ghosh on 01/01/23.
//

import UIKit

class TableViewCell: UITableViewCell {

    var vard : UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

   private func setup()
    {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        let vard = UIImageView()
        vard.backgroundColor = .green
        vard.frame = CGRect(x: 10, y: 10, width: 50, height: 50)
        self.vard = vard
        self.addSubview(vard)

    }
    
    override func layoutSubviews() {
        vard.layer.cornerRadius = vard.bounds.height / 2
        vard.clipsToBounds = true
    }

}
