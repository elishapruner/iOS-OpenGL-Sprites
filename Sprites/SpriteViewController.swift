//
//  ViewController.swift
//  Sprites
//
//  Created by Elisha Pruner on 2017-06-16.
//  Copyright © 2017 Elisha Pruner. All rights reserved.
//

import GLKit

class SpriteViewController: GLKViewController {
    
    private var glkView: GLKView {
        return view as! GLKView
    }
    
    private var mario: Sprite?
    private var luigi: Sprite?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        glkView.context = EAGLContext(api: .openGLES2)
        EAGLContext.setCurrent(glkView.context)
        
        // Enable alpha blending
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        
        mario = Sprite(image: UIImage(named: "mario_texture")!)
        luigi = Sprite(image: UIImage(named: "luigi_texture")!)
    }
    
    func update() {
        let translateX: Float = 0.002
        let translateY: Float = 0.003
        mario?.positionX = (mario?.positionX)! + translateX
        mario?.positionY = (mario?.positionY)! + translateY
        luigi?.positionX = (luigi?.positionX)! - translateX
        luigi?.positionY = (luigi?.positionY)! + translateY
        
        let scaleFactor: Float = 0.001
        mario?.scaleX = (mario?.scaleX)! + scaleFactor
        mario?.scaleY = (mario?.scaleY)! + scaleFactor
        luigi?.scaleX = (luigi?.scaleX)! + scaleFactor
        luigi?.scaleY = (luigi?.scaleY)! + scaleFactor
        
        let rotation: Float = 3.14
        mario?.rotation = rotation
        luigi?.rotation = rotation
    }
    
    override func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClearColor(0.75, 0.75, 0.75, 1.0)
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        
        mario?.draw()
        luigi?.draw()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

