//
//  ViewController.swift
//  teste3PDF
//
//  Created by humberto Lima on 01/04/19.
//  Copyright © 2019 humberto Lima. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController, PDFDocumentDelegate {
    
    //edit schames - verbose está la
    
    @IBOutlet weak var campoTexto: UITextField!
    @IBOutlet var pdfView: PDFView!
    
    var paginas = [Int]()
    var paginasEncontradas = [PDFSelection]()
    
    var paginaAtual = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buscarNoPDF(textoBuscar: "")
    }
    
    @IBAction func buscaTexto(_ sender: UITextField) {
        buscarNoPDF(textoBuscar: campoTexto.text! )
    }

    func buscarNoPDF(textoBuscar: String) {
        if textoBuscar != "" {
            if let path = Bundle.main.path(forResource: "alg-handout", ofType: ".pdf") {
                let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path))!
                pdfDocument.delegate = self
                // cuidado ao usar esse cara com o campo de texto, ele vai percorrer o PDF todo
                // comecei a digitar Tabl... ele buscou todos os "t" da página
                //pdfDocument.beginFindString(campoTexto.text!, withOptions: .caseInsensitive)
                pdfDocument.beginFindString("About the ", withOptions: .caseInsensitive)
            }
        }else{
            if let path = Bundle.main.path(forResource: "alg-handout", ofType: ".pdf") {
                if let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path)) {
                    pdfView.displayMode = .singlePageContinuous
                    pdfView.autoScales = true
                    pdfView.displayDirection = .vertical
                    pdfView.document = pdfDocument
                }
            }
        }
    }
    
    func didMatchString(_ instance: PDFSelection) {
        paginasEncontradas.append(instance)
        paginas.append(instance.pages[0].pageRef!.pageNumber)
        pdfView.go(to: paginasEncontradas.first!)
    }

    @IBAction func mudaPagina(_ sender: UIButton) {
        
        if paginasEncontradas.count > 0 {
            if sender.tag == 1 { // avancar proxima pagina
                if paginaAtual + 1 < paginasEncontradas.count {
                    paginaAtual += 1
                    pdfView.document?.page(at: paginas[paginaAtual])
                    let document = pdfView.document!
                    if let paginaAcessar = document.page(at:paginas[paginaAtual]) {
                        pdfView.go(to: paginaAcessar)
                    }
                }
            }else{
                if paginaAtual >= 1 {
                    paginaAtual -= 1
                    pdfView.document?.page(at: paginas[paginaAtual])
                    let document = pdfView.document!
                    if let paginaAcessar = document.page(at:paginas[paginaAtual]) {
                        pdfView.go(to: paginaAcessar)
                    }
                }
            }
        }
    }
}
