class TinymceAssetsController < ApplicationController
  def create
    # Take upload from params[:file] and store it somehow...
    # Optionally also accept params[:hint] and consume if needed
    file = params[:file]
    url = upload_image(file)
    render json: {
      image: {
        url: url
      }
    }, content_type: "text/html"
  end

  private
  def upload_image(file)
    # 파일 업로드 => URL 리턴
    s3 = Aws::S3::Resource.new(region: ENV['AWS_REGION'])
    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object('posts/content/'+filename(file))
    obj.upload_file(file.tempfile, {acl: 'public-read'})
    obj.public_url.to_s
  end

  def filename(file)
    "#{Time.now.to_i}_#{file.original_filename}"
  end
end
