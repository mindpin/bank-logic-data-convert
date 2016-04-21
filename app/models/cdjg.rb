=begin
XMDM: 项目代码
XMMC: 项目名称 *
JYJB: 交易级别
CDDM: 菜单代码
 ZCD: 子菜单
CLCX: 处理程序
JYDM: 交易代码 *
=end


class Cdjg
  include Mongoid::Document

  field :xmdm
  field :xmmc
  field :jyjb
  field :cddm
  field :zcd
  field :clcx
  field :jydm

  def self.menu_root
    Cdjg.where(zcd: '000000').first
  end

  def children
    return [] if self.zcd.blank?
    Cdjg.where(cddm: self.zcd)
  end

  def data
    {
      id:   id.to_s,
      xmmc: xmmc.strip,
      jydm: jydm.present? ? jydm : ''
    }
  end
end
