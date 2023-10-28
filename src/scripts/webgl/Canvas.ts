import * as THREE from 'three'
import { three } from './core/Three'
import fragmentShader from './shader/point.fs'
import vertexShader from './shader/point.vs'

export class Canvas {
  private readonly POINT_SET = { row: 3000, col: 5 }
  private points: THREE.Points<THREE.BufferGeometry, THREE.RawShaderMaterial>

  constructor(canvas: HTMLCanvasElement) {
    this.init(canvas)
    this.points = this.createPoints()
    three.animation(this.anime)
  }

  private init(canvas: HTMLCanvasElement) {
    three.setup(canvas)
    three.scene.background = new THREE.Color('#000')
  }

  private createPoints() {
    const geometry = new THREE.BufferGeometry()

    const points: number[] = []

    for (let r = 0; r < this.POINT_SET.row; r++) {
      for (let c = 0; c < this.POINT_SET.col; c++) {
        points.push(r / this.POINT_SET.row, c / this.POINT_SET.col, 0)
      }
    }

    geometry.setAttribute('position', new THREE.Float32BufferAttribute(points, 3))

    const material = new THREE.RawShaderMaterial({
      uniforms: {
        uTime: { value: 0 },
      },
      vertexShader,
      fragmentShader,
      depthTest: false,
      blending: THREE.AdditiveBlending,
    })
    const mesh = new THREE.Points(geometry, material)
    three.scene.add(mesh)
    return mesh
  }

  private anime = () => {
    this.points.material.uniforms.uTime.value += three.time.delta
    three.render()
  }

  dispose() {
    three.dispose()
  }
}
