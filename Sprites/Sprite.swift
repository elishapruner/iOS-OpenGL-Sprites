//
//  Sprite.swift
//  Sprites
//
//  Created by Elisha Pruner on 2017-06-17.
//  Copyright © 2017 Elisha Pruner. All rights reserved.
//

import GLKit

class Sprite {
    
    private static var program: GLuint = 0
    
    var positionX: Float = 0.0
    var positionY: Float = 0.0
    
    var scaleX: Float = 1.0
    var scaleY: Float = 1.0
    
    var rotation: Float = 0.0
    
    let image: UIImage
    let texture: GLKTextureInfo
    
    private static let quad: [Float] = [
        1.0, -1.0,   // Point (x, y)
        1.0, 1.0,   // Texture Coordinates (x, y)
        1.0, 0.0, 0.0, 1.0, // Color (rgba)
        
        -1.0, -1.0,
        0.0, 1.0,
        0.0, 1.0, 0.0, 1.0,
        
        1.0, 1.0,
        1.0, 0.0,
        0.0, 0.0, 1.0, 1.0,
        
        -1.0, 1.0,
        0.0, 0.0,
        1.0, 1.0, 0.0, 1.0
    ]
    
    init(image: UIImage) {
        self.image = image
        texture = try! GLKTextureLoader.texture(with: image.cgImage!, options: nil)
        
        Sprite.setup()

    }
    
    private static func setup() {
        // if program is already created return
        if program != 0 {
            return
        }
        
        // Compile Vertex Shader
        let vertexShaderPath: String = Bundle.main.path(forResource: "vertex_shader", ofType: "glsl", inDirectory: nil)!
        
        let vertexShaderSource: NSString = try! NSString(contentsOfFile: vertexShaderPath, encoding: String.Encoding.utf8.rawValue)
        
        var vertexShaderData = vertexShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let vertexShader:GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        glShaderSource(vertexShader, 1, &vertexShaderData, nil)
        glCompileShader(vertexShader)
        
        var vertexCompileStatus: GLint = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &vertexCompileStatus)
        
        if vertexCompileStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            glGetShaderInfoLog(vertexShader, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            print(logString)
            fatalError("compilation of vertex shader failed")
        }
        
        // Compile Fragment Shader
        let fragmentShaderPath: String = Bundle.main.path(forResource: "fragment_shader", ofType: "glsl", inDirectory: nil)!
        
        let fragmentShaderSource: NSString = try! NSString(contentsOfFile: fragmentShaderPath, encoding: String.Encoding.utf8.rawValue)
        
        var fragmentShaderData = fragmentShaderSource.cString(using: String.Encoding.utf8.rawValue)
        
        let fragmentShader:GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        glShaderSource(fragmentShader, 1, &fragmentShaderData, nil)
        glCompileShader(fragmentShader)
        
        var fragmentCompileStatus: GLint = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentCompileStatus)
        
        if fragmentCompileStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            glGetShaderInfoLog(fragmentShader, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            print(logString)
            fatalError("compilation of fragment shader failed")
        }
        
        // Link program
        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glBindAttribLocation(program, 0, "position")
        glBindAttribLocation(program, 1, "texture")
        glBindAttribLocation(program, 2, "color")
        glLinkProgram(program)
        
        var linkStatus: GLint = GL_FALSE
        glGetProgramiv(program, GLenum(GL_LINK_STATUS), &linkStatus)
        
        if linkStatus == GL_FALSE {
            var logLength: GLint = 0
            glGetProgramiv(program, GLenum(GL_INFO_LOG_LENGTH), &logLength)
            
            let logBuffer = UnsafeMutablePointer<GLchar>.allocate(capacity: Int(logLength))
            glGetProgramInfoLog(program, logLength, nil, logBuffer)
            
            let logString = String(cString: logBuffer)
            print(logString)
            fatalError("Linking program failed")
        }
        
        glUseProgram(program)
        glEnableVertexAttribArray(0)
        glEnableVertexAttribArray(1)
        glEnableVertexAttribArray(2)

    }
    
    func draw() {
        // Position
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, Sprite.quad)
        
        // Texture
        glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, Sprite.quad)
        
        // Color
        glVertexAttribPointer(2, 4, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 32, UnsafePointer(Sprite.quad) + 4)
        
        // Transformations
        glUniform2f(glGetUniformLocation(Sprite.program, "translate"), positionX, positionY)
        glUniform2f(glGetUniformLocation(Sprite.program, "scale"), scaleX, scaleY)
        glUniform1f(glGetUniformLocation(Sprite.program, "rotation"), rotation)
        
        // Bind the texture
        glBindTexture(GLenum(GL_TEXTURE_2D), texture.name)
        
        // Draw the triangles
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
}
