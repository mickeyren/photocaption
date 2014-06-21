module ApplicationHelper
  def templates(root)
    pattern = File.join(root, '**/*.html.slim')

    Dir.glob(pattern).map do |path|
      path.gsub(%r|^#{root}/|, '').gsub(/.slim$/,'')
    end
  end
end
