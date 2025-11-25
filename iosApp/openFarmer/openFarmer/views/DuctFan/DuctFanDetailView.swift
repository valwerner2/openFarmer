//
//  DuctFanDetailView.swift
//  openFarmer
//
//  Created by Valentin Werner on 23.11.25.
//

import SwiftUI

struct DuctFanDetailView: View {
    let ductFan: DuctFan 
    
    @State var ductFanCopy: DuctFan?
    
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        VStack(alignment: .leading){
            DuctFanInfoBar(ductFanCurrent: ductFan)
            if editMode?.wrappedValue.isEditing == true {
                if let ductFanToEdit = ductFanCopy{
                    DuctFanDetailEditView(ductFanCurrent: ductFan, ductFanEdit: ductFanToEdit)
                }
            }
        }
        .onChange(of: editMode?.wrappedValue.isEditing) { _, isEditing in
            self.ductFanCopy = ductFan
        }
    }
}
